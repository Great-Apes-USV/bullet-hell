class_name Enemy
extends Entity


var player : Player


func _init(new_player : Player = null):
	player = new_player


func _physics_process(delta):
	if player:
		look_at(player.position)
		velocity = Vector2.from_angle(rotation) * speed;
		move_and_slide()
