extends Node2D

@onready var viewport_scale : float = get_viewport_transform().get_scale().x # aspect ratio locked
@onready var window_size : Vector2i = DisplayServer.window_get_size() / viewport_scale
@onready var aspect_ratio : float = float(window_size.x) / window_size.y
@onready var gap : Vector2i
@onready var world: DungeonWorld = $World
@onready var player: Player = $Player


func _ready():
	GameHandler.game = self
	GameHandler.world = world
	GameHandler.player = player
	GameHandler.enemies = $Enemies
	GameHandler.bullets = $Bullets
	var diff : Vector2i = window_size - world.rect.size
	if diff.x > diff.y:
		window_size *= float(world.rect.size.x) / window_size.x
	else:
		window_size *= float(world.rect.size.y) / window_size.y
	gap = window_size - world.rect.size
	get_viewport().content_scale_size = window_size
	position = (window_size - world.rect.size) / 2
	
	get_viewport().size_changed.connect(_on_viewport_resize)
	
	player.position = world.player_spawn


func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if player.position.y <= player.sprite_width / 2:
		world.change_room(0) # DungeonWorld.Directions.UP
		player.position.y = world.rect.size.y - player.sprite_width - 64
	if player.position.y >= world.rect.size.y - player.sprite_width / 2:
		world.change_room(1) # DungeonWorld.Directions.DOWN
		player.position.y = player.sprite_width + 64
	if player.position.x <= player.sprite_width / 2:
		world.change_room(2) # DungeonWorld.Directions.LEFT
		player.position.x = world.rect.size.x - player.sprite_width - 64
	if player.position.x >= world.rect.size.x - player.sprite_width / 2:
		world.change_room(3) # DungeonWorld.Directions.RIGHT
		player.position.x = player.sprite_width + 64
	


func _on_viewport_resize():
	viewport_scale = get_viewport_transform().get_scale().x # aspect ratio locked
	window_size = DisplayServer.window_get_size() / viewport_scale
	
	position = (window_size - world.rect.size) / 2
