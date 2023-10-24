extends Node2D


func _ready():
	NavigationServer2D.map_set_cell_size($World.get_world_2d().navigation_map, 0.25)
