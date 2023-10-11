class_name Weapon
extends Resource

@export var name : String
@export var player : Player

@export var bullet_scene : PackedScene = preload("res://weapons/bullet.tscn")

@export var damage : int = 1
@export var fire_rate : float = 10
@export var bullet_speed : float = 1000
@export var bullet_range : float = 2000
@export var fire_mode : int = Weapons.FireMode.SEMI
@export var magazine_size : int = 100
@export var reload_speed : float = 2

var current_magazine : int = magazine_size

var reload_timer = Timer.new()

var firing : bool = false
var reloading : bool = false
var needs_reload : bool:
	get: return current_magazine <= 0

func _init(new_player : Player = Player.new()):
	player = new_player
	# must wait for tree to finish setting up children
	player.get_tree().root.add_child.call_deferred(reload_timer)

func fire():
	if firing or current_magazine <= 0 or reloading:
		return
	firing = true
	current_magazine -= 1
	spawn_bullets()
	await wait_fire_rate()
	firing = false

func create_bullet() -> Bullet:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.speed = bullet_speed
	bullet.damage = damage
	bullet.bullet_range = bullet_range
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
	reload_timer.start(reload_speed)
	await reload_timer.timeout
	if not reload_timer.is_stopped():
		current_magazine = magazine_size
	reloading = false

func interrupt_reload():
	reload_timer.stop()
	reload_timer.timeout.emit()
