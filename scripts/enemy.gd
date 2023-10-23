class_name Enemy
extends Entity


@export var damage : int = 5

var player : Player


func _init(new_player : Player = null):
	player = new_player


func _physics_process(delta):
	if player:
		look_at(player.position)
		var collision : KinematicCollision2D = move_and_collide(Vector2.from_angle(rotation) * speed * delta)
		if collision and collision.get_collider() == player:
			player.take_damage(damage)
			die()
