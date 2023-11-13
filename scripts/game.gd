extends Node2D

@onready var viewport_scale : float = get_viewport_transform().get_scale().x # aspect ratio locked
@onready var window_size : Vector2i = DisplayServer.window_get_size() / viewport_scale
@onready var aspect_ratio : float = float(window_size.x) / window_size.y
@onready var gap : Vector2i


func _ready():
	var diff : Vector2i = window_size - $World.rect.size
	if diff.x > diff.y:
		window_size *= float($World.rect.size.x) / window_size.x
	else:
		window_size *= float($World.rect.size.y) / window_size.y
	gap = window_size - $World.rect.size
	get_viewport().content_scale_size = window_size
	position = (window_size - $World.rect.size) / 2
	
	get_viewport().size_changed.connect(_on_viewport_resize)


func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if Input.is_action_just_pressed("show_menu"):
		$LevelSelectMenu.visible = not $LevelSelectMenu.visible


func _on_viewport_resize():
	viewport_scale = get_viewport_transform().get_scale().x # aspect ratio locked
	window_size = DisplayServer.window_get_size() / viewport_scale
	
	position = (window_size - $World.rect.size) / 2

