class_name Bullet
extends RigidBody2D

const MAX_LIFETIME : int = 10

static var bullet_id = 0

var speed : float
var damage : int
var bullet_range : float

var distance_traveled : float = 0

func _enter_tree():
	name = "Bullet_%d" % bullet_id
	bullet_id += 1 
	linear_velocity = Vector2.from_angle(rotation) * speed
	die_after_seconds(MAX_LIFETIME)

func _process(delta):
	distance_traveled += delta * speed
	if distance_traveled >= bullet_range:
		queue_free()

func _physics_process(_delta):
	for body in get_colliding_bodies():
#		if body is Enemy:
#			body.take_damage(damage)
		if body is StaticBody2D:
			queue_free()
	pass

func die_after_seconds(seconds : float):
	await get_tree().create_timer(seconds).timeout
	queue_free()
