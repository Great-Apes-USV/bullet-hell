extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.pressed.connect(button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func button_pressed():
	var level_name = $TextureButton.get_meta("LevelName")  # Replace with the path to your level scene
	var level = load(level_name).instantiate()
	$/root/Game/World.add_child(level)
	print("level loaded")
