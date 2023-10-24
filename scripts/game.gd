extends Node2D


func _ready():
	get_viewport().size_changed.connect(_on_viewport_resize)


func _on_viewport_resize():
	var viewport_scale : float = get_viewport_transform().get_scale().x # aspect ratio locked
	var window_size : Vector2i = DisplayServer.window_get_size() / viewport_scale
	
	position.x = (window_size.x - $World.rect.size.x) / 2
	position.y = (window_size.y - $World.rect.size.y) / 2
