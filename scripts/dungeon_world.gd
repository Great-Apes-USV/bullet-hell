class_name DungeonWorld
extends LDTKWorld

enum Directions {UP=0, DOWN=1, LEFT=2, RIGHT=3}

# ATTN: this will be a 3d array, with each "level" location being an array with its level id [0]
# and a cleared level flag [1]
var layout : Array[Array] = [
	[9, 15, 22],
	[9, 18, 8],
	[-1, 11, 16],
	[-1, 17, 19],
	[-1, 21, -1]
]

var room_pos := Vector2i(0, 0)
var dungeon_dimensions := Vector2i(3, 5)
var player_spawn := Vector2i(768, 512)


func _init():
	var y_size: int = layout.size()
	var x_size: int = layout[0].size()
	for y in range(y_size):
		for x in range(x_size):
			layout[y][x] = [layout[y][x], false]
	layout[0][0][1] = true


func _ready():
	change_level(layout[room_pos.y][room_pos.x][0])
	room_cleared()


func _process(delta):
	pass


func get_level(level_room_pos: Vector2i = room_pos) -> int:
	return layout[level_room_pos.y][level_room_pos.x][0]


func get_level_cleared(level_room_pos: Vector2i = room_pos) -> bool:
	return layout[level_room_pos.y][level_room_pos.x][1]


func update_room(level_room_pos: Vector2i = room_pos):
	var level: LDTKLevel = change_level(get_level(level_room_pos))
	if get_level_cleared() == false:
		var enemy_spawns = level.find_child("EnemySpawns")
		if enemy_spawns:
			enemy_spawns.spawn_all()
	if $/root/Game/Enemies.get_children().size() <= 0:
		room_cleared()


func change_room(direction: Directions):
	if not get_level_cleared():
		return
	match direction:
		Directions.UP:
			room_pos.y -= 1
			if room_pos.y < 0 or get_level() == -1:
				room_pos.y += 1
		Directions.DOWN:
			room_pos.y += 1
			if room_pos.y >= dungeon_dimensions.y or get_level() == -1:
				room_pos.y -= 1
		Directions.LEFT:
			room_pos.x -= 1
			if room_pos.x < 0 or get_level() == -1:
				room_pos.x += 1
		Directions.RIGHT:
			room_pos.x += 1
			if room_pos.x >= dungeon_dimensions.x or get_level() == -1:
				room_pos.x -= 1
	update_room()


func room_cleared():
	layout[room_pos.y][room_pos.x][1] = true
	for level in get_children():
		if "Level_" in level.name:
			var gates = level.find_child("Gates")
			if gates:
				gates.queue_free()
