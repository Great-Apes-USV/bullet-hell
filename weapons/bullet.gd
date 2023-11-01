class_name Bullet
extends RigidBody2D


const MAX_LIFETIME : int = 10
const MAX_PIERCE : int = 1

static var bullet_id : int = 0

var ExplosionNode : PackedScene = preload("res://weapons/bullet.tscn")
var explosion_node : Node2D

var speed : float
var damage : int
var bullet_range : float
var piercing : bool
var ricochet : bool
var explode : bool

var velocity : Vector2
var distance_traveled : float = 0
var bodies_pierced = 0
var still_piercing : Array[Node2D] = []
var can_pierce : bool:
	get: return piercing and bodies_pierced < MAX_PIERCE


func _enter_tree():
	name = "Bullet_%d" % bullet_id
	bullet_id += 1 
	die_after_seconds(MAX_LIFETIME)


func _ready():
	$Area2D.area_exited.connect(reenable_collision)
	$Area2D.body_exited.connect(reenable_collision)
	explosion_node = get_node(^"/root/Game/Bullets")


func _process(delta):
	distance_traveled += delta * speed
	if distance_traveled >= bullet_range:
		die()


func _physics_process(delta):
	var touching_bodies : Array[Node2D] = []
	velocity = Vector2.from_angle(rotation) * speed * delta
	var test_collision : KinematicCollision2D = move_and_collide(velocity)
	if test_collision:
		var body := test_collision.get_collider() as Node2D
		if ricochet:
			var normal := Vector2.from_angle(test_collision.get_angle())
			rotation = Vector2.from_angle(rotation).reflect(normal).angle()
		touching_bodies.append(body)
	touching_bodies.append_array($Area2D.get_overlapping_bodies())
	
	for body in touching_bodies:
		if still_piercing.has(body): # already processed
			continue
		
		if body is Enemy:
			body.take_damage(damage)
		
		if ricochet and not body is Enemy:
			continue
		
		if can_pierce:
			still_piercing.append(body)
			bodies_pierced += 1
			continue
			
		
		die()
		break

#var bullet = create_bullet()
#		bullet.rescale(Vector2(2, 1))
#		bullets_node.add_child(bullet)

func reenable_collision(body : Node2D):
	still_piercing.erase(body)
	if not can_pierce:
		piercing = false


func die_after_seconds(seconds : float):
	await get_tree().create_timer(seconds).timeout
	die()


func rescale(ratio : Vector2):
	$Sprite2D.scale *= ratio
	$MeshInstance2D.scale *= ratio
	$CollisionShape2D.scale *= ratio


func die(): # for actions when freeing
	if(explode):
		velocity = Vector2.ZERO
		print_debug(velocity)
		var explosion = ExplosionNode.instantiate() as Bullet
		explosion.position = position
		explosion.rescale(Vector2(7,7))
		explosion_node.add_child(explosion)
		await get_tree().create_timer(0.5).timeout
	queue_free()
