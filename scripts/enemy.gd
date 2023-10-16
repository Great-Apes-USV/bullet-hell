extends Entity

var player : Player


func _init(new_player := Player.new()):
	player = new_player

func _physics_process(delta):
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		move_and_slide()


