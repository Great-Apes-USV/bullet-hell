extends Control

@onready var current_level = $/root/Game/World/Level_0


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.pressed.connect(button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func button_pressed():
	print("pressed")
	var level_name = $TextureButton.get_meta("LevelName")
	current_level.queue_free()
	var level = load(level_name).instantiate()
	current_level = level
	$/root/Game/World.add_child(level)
	print("level loaded")
