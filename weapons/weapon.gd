class_name Weapon
extends Resource

@export var name : String
@export var type : Weapons.WeaponType:
	get: return _get_type()
@export var player : Player

@export var bullet_scene : PackedScene = preload("res://weapons/bullet.tscn")

@export var damage : int = 1
@export var fire_rate : float = 10
@export var bullet_speed : float = 1000
@export var bullet_range : float = 2000
@export var fire_mode : int = Weapons.FireMode.SEMI
@export var max_ammo : int = 100
@export var reload_speed : float = 2

var preset_name : String = ""
var current_ammo : int = max_ammo

var reload_timer : Timer = Timer.new()
var bullets_node : Node2D

var firing : bool = false
var reloading : bool = false
var needs_reload : bool:
	get: return current_ammo <= 0

func _init(new_player : Player = Player.new(), properties : Dictionary = {}):
	player = new_player
	set_props_from_dict(properties, true)
	# must wait for tree to finish setting up children
	player.get_tree().root.add_child.call_deferred(reload_timer)
	bullets_node = player.get_tree().root.get_node(^"/root/Game/Bullets")

func set_props_from_dict(properties : Dictionary = {}, is_new_weapon : bool = false):
	for key in properties:
		var value = properties[key]
		match key:
			"damage":
				damage = value
			"fire_rate":
				fire_rate = value
			"bullet_speed":
				bullet_speed = value
			"bullet_range":
				bullet_range = value
			"fire_mode":
				fire_mode = value
			"max_ammo":
				max_ammo = value
				if is_new_weapon:
					current_ammo = max_ammo
			"reload_speed":
				reload_speed = value

func fire():
	if firing or current_ammo <= 0 or reloading:
		return
	firing = true
	current_ammo -= 1
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
	bullets_node.add_child(bullet)

func wait_fire_rate():
	# reciprocal of fire_rate = seconds per bullet
	await player.get_tree().create_timer(1 / fire_rate).timeout

func reload():
	reloading = true
	reload_timer.start(reload_speed)
	await reload_timer.timeout
	if not reload_timer.is_stopped():
		current_ammo = max_ammo
	reloading = false

func interrupt_reload():
	reload_timer.stop()
	reload_timer.timeout.emit()

func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.ANY
