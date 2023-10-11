class_name Bullet
extends RigidBody2D

var speed : float
var damage : int
var range : float

var distance_traveled : float

func _enter_tree():
	linear_velocity = Vector2.from_angle(rotation) * speed
	die_after_seconds(10)

func _process(delta):
	distance_traveled += delta * speed
	if distance_traveled >= range:
		queue_free()

func _physics_process(delta):
	for node in get_colliding_bodies():
#		if node is Enemy:
#			node.take_damage(damage)
		if node is StaticBody2D:
			queue_free()
	pass

func die_after_seconds(seconds : float):
	await get_tree().create_timer(seconds).timeout
	queue_free()
