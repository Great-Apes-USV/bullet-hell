extends Node


var game: Node2D
var world: DungeonWorld
var player: Player
var enemies: Node2D
var bullets: Node2D
var start_window_size: Vector2i


func reset_viewport():
	get_viewport().content_scale_size = start_window_size
