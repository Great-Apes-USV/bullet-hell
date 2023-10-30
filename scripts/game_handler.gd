extends Node2D


var _global_offset : Vector2
var mouse_position : Vector2:
	get: return get_global_mouse_position() - _global_offset
