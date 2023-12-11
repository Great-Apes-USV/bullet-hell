class_name DungeonWorld
extends LDTKWorld

enum Directions {UP=0, DOWN=1, LEFT=2, RIGHT=3}

var dungeon_layout: PackedInt32Array = [9, 15, 22, 9, 18, 8, -1, 11, 16, -1, 17, 19, -1, 21, -1]
var room_cleared_status: PackedByteArray
var room_cleared_count: int = 0

var current_room_position := Vector2i(0, 0)
var dungeon_dimensions := Vector2i(3, 5)
var player_spawn := Vector2i(768, 512)


func _init():
	for i in range(dungeon_layout.size()):
		if dungeon_layout[i] == -1:
			room_cleared_count += 1
			room_cleared_status.append(true)
			continue
		room_cleared_status.append(false)
	room_cleared_status[0] = true


func _ready():
	change_level(dungeon_layout[get_room_index()])
	clear_room()


func get_room_index(level_room_pos: Vector2i = current_room_position) -> int:
	return level_room_pos.y * dungeon_dimensions.x + level_room_pos.x


func get_room_id(level_room_pos: Vector2i = current_room_position) -> int:
	return dungeon_layout[get_room_index(level_room_pos)]


func get_room_cleared(level_room_pos: Vector2i = current_room_position) -> bool:
	return room_cleared_status[get_room_index(level_room_pos)]


func update_room(level_room_pos: Vector2i = current_room_position):
	var level: LDTKLevel = change_level(get_room_id(level_room_pos))
	if not get_room_cleared():
		var enemy_spawns = level.find_child("EnemySpawns")
		if enemy_spawns:
			enemy_spawns.spawn_all()
		if GameHandler.enemies.get_children().size() <= 0:
			clear_room()
	else:
		var gates = level.find_child("Gates")
		if gates:
			gates.queue_free()


func change_room(direction: Directions):
	if not get_room_cleared():
		return
	match direction:
		Directions.UP:
			current_room_position.y -= 1
			if current_room_position.y < 0 or get_room_id() == -1:
				current_room_position.y += 1
		Directions.DOWN:
			current_room_position.y += 1
			if current_room_position.y >= dungeon_dimensions.y or get_room_id() == -1:
				current_room_position.y -= 1
		Directions.LEFT:
			current_room_position.x -= 1
			if current_room_position.x < 0 or get_room_id() == -1:
				current_room_position.x += 1
		Directions.RIGHT:
			current_room_position.x += 1
			if current_room_position.x >= dungeon_dimensions.x or get_room_id() == -1:
				current_room_position.x -= 1
	update_room()


func clear_room():
	room_cleared_status[get_room_index()] = true
	room_cleared_count += 1
	print(dungeon_layout.size() - room_cleared_count)
	if room_cleared_count == dungeon_layout.size():
		var label = GameUI.find_child("Label_Message")
		label.text = "Congratulations!"
#		GameHandler.reset_viewport()
#		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	for level in get_children():
		if "Level_" in level.name:
			var gates = level.find_child("Gates")
			if gates:
				gates.queue_free()
