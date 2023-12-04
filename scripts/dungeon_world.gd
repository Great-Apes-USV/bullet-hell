class_name DungeonWorld
extends LDTKWorld

enum Directions {UP=0, DOWN=1, LEFT=2, RIGHT=3}

var layout : Array[Array] = [
	[9, 15, 20],
	[9, 18, 8],
	[-1, 11, 16],
	[-1, 17, 19],
	[-1, 21, -1]
]

var room_pos := Vector2i(0, 0)
var dungeon_dimensions := Vector2i(3, 5)
var player_spawn := Vector2i(768, 512)


func _ready():
	change_level(layout[room_pos.y][room_pos.x])


func _process(delta):
	pass


func get_level(level_room_pos: Vector2i = room_pos) -> int:
	return layout[room_pos.y][room_pos.x]


func update_room(level_room_pos: Vector2i = room_pos):
	change_level(get_level())


func change_room(direction: Directions):
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
