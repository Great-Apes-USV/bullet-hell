extends CharacterBody2D

@export var speed : float = 200

var move_vector : Vector2 = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	$Sprite2D.look_at(get_global_mouse_position())
	# respects circular deadzone
	move_vector = Input.get_vector("move-left", "move-right", "move-up", "move-down")

func _physics_process(delta):
	velocity = move_vector * speed
	move_and_slide()
