class_name Bullet
extends RigidBody2D


const MAX_LIFETIME : int = 10
const MAX_PIERCE : int = 1

static var bullet_id : int = 0

var speed : float
var damage : int
var bullet_range : float
var piercing : bool
var ricochet : bool

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


func _process(delta):
	distance_traveled += delta * speed
	if distance_traveled >= bullet_range:
		die()


func _physics_process(delta):
	var touching_bodies : Array[Node2D] = []
	var test_collision : KinematicCollision2D = move_and_collide(Vector2.from_angle(rotation) * speed * delta)
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
		
		if can_pierce and not body.collision_layer & 1:
			still_piercing.append(body)
			bodies_pierced += 1
			continue
		
		if ricochet and not body is Enemy:
			continue
		
		die()
		break


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
	queue_free()
