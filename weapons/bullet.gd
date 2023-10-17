class_name Bullet
extends RigidBody2D


const MAX_LIFETIME : int = 10

static var bullet_id : int = 0

var speed : float
var damage : int
var bullet_range : float
var piercing : bool

var distance_traveled : float = 0
var pierced_bodies : Array[StaticBody2D] = []


func _enter_tree():
	name = "Bullet_%d" % bullet_id
	bullet_id += 1 
	linear_velocity = Vector2.from_angle(rotation) * speed
	die_after_seconds(MAX_LIFETIME)


func _process(delta):
	distance_traveled += delta * speed
	if distance_traveled >= bullet_range:
		die()


func _physics_process(_delta):
	for body in get_colliding_bodies():
#		if body is Enemy:
#			body.take_damage(damage)
		if body is StaticBody2D:
			if piercing:
				if pierced_bodies.size() == 0:
					pierced_bodies.append(body)
					continue
				elif pierced_bodies.has(body):
					continue
			die()
			break


func die_after_seconds(seconds : float):
	await get_tree().create_timer(seconds).timeout
	die()


func rescale(ratio : Vector2):
	$Sprite2D.scale *= ratio
	$MeshInstance2D.scale *= ratio
	$CollisionShape2D.scale *= ratio


func die(): # for actions when freeing
	queue_free()
