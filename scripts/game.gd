extends Node2D


func _ready():
	get_viewport().size_changed.connect(_on_viewport_resize)


func _on_viewport_resize():
	var fake_size : Vector2i = get_viewport_transform().get_scale().x * $World.rect.size
	var window_size : Vector2i = DisplayServer.window_get_size()
	
	position.x = ((window_size.x - fake_size.x) / 2) / get_viewport_transform().get_scale().x
	position.y = ((window_size.y - fake_size.y) / 2) / get_viewport_transform().get_scale().y
