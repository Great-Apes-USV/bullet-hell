extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.pressed.connect(button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func button_pressed():
	var level_name = "res://scenes/game.tscn"  # Replace with the path to your level scene
	get_tree().change_scene(level_name)
	print("level loaded")
