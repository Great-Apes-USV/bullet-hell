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
@export var magazine_size : int = 100
@export var reload_speed : float = 2

var current_magazine : int = magazine_size

var firing : bool = false
var reloading : bool = false
var needs_reload : bool:
	get: return current_magazine <= 0

func _init(new_player : Player = Player.new()):
	player = new_player

func fire():
	if not firing and current_magazine > 0 and not reloading:
		firing = true
		current_magazine -= 1
		spawn_bullets()
		await wait_fire_rate()
		firing = false

func create_bullet() -> Bullet:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.speed = bullet_speed
	bullet.damage = damage
	bullet.range = range
	bullet.position = player.position
	bullet.rotation = player.sprite.rotation
	return bullet

func spawn_bullets():
	var bullet = create_bullet()
	player.get_tree().root.add_child(bullet)

func wait_fire_rate():
	# reciprocal of fire_rate = seconds per bullet
	await player.get_tree().create_timer(1 / fire_rate).timeout

func reload():
	reloading = true
	await player.get_tree().create_timer(reload_speed).timeout
	current_magazine = magazine_size
	reloading = false
