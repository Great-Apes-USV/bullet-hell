class_name Weapon
extends Resource

@export var name : String
@export var player : Player

@export var bullet_scene : PackedScene = preload("res://weapons/bullet.tscn")

@export var damage : int = 1
@export var fire_rate : float = 10
@export var bullet_speed : float = 1000
@export var range : float = 2000
@export var fire_mode : int = Weapons.FireMode.SEMI

var firing : bool = false

func _init(new_player : Player = Player.new()):
	player = new_player

func fire():
	if not firing:
		firing = true
		create_bullet()
		await wait_fire_rate()
		firing = false

func create_bullet():
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.speed = bullet_speed
	bullet.damage = damage
	bullet.range = range
	bullet.position = player.position
	bullet.rotation = player.sprite.rotation
	player.get_tree().root.add_child(bullet)

func wait_fire_rate():
	# reciprocal of fire_rate = seconds per bullet
	await player.get_tree().create_timer(1 / fire_rate).timeout
