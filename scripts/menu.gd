extends Control


func _ready():
	%Button_StartGame.pressed.connect(_start_game)
	%Button_Quit.pressed.connect(_quit_game)


func _start_game():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _quit_game():
	get_tree().quit()
