@icon("ldtk-world.svg")
class_name LDTKWorld
extends Node2D

@export var level_count: int = 7
@export var rect: Rect2i

var levels: Array[PackedScene]
var current_level: Node
var current_level_index: int = 0

func _init():
	for i in range(level_count):
		levels.append(load("res://levels/level_%d.tscn" % i))


func _enter_tree():
	current_level = levels[current_level_index].instantiate()
	add_child(current_level)


func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		current_level_index += 1
		if current_level_index >= level_count:
			current_level_index = 0
		current_level.queue_free()
		current_level = levels[current_level_index].instantiate()
		add_child(current_level)
	if Input.is_action_just_pressed("ui_left"):
		current_level_index -= 1
		if current_level_index < 0:
			current_level_index = level_count - 1
		current_level.queue_free()
		current_level = levels[current_level_index].instantiate()
		add_child(current_level)
