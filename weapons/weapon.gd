class_name Weapon
extends Resource


@export var name : String
@export var type : Weapons.WeaponType = _get_type()
@export var player : Player
@export var BulletNode : PackedScene = preload("res://weapons/bullet.tscn")
@export var properties = {
	damage = 1,
	fire_rate = 10,
	bullet_speed = 1000,
	bullet_range = 2000,
	fire_mode = Weapons.FireMode.SEMI,
	max_ammo = 100,
	reload_speed = 2,
	reload_delay = 0.15,
	piercing = false,
}

var preset_name := ""
var current_ammo : int = properties.max_ammo
var reload_timer := Timer.new()
var bullets_node : Node2D
var firing := false
var reloading := false
var delaying_reload := false
var no_ammo : bool:
	get: return current_ammo <= 0
var full_ammo : bool:
	get: return current_ammo == properties.max_ammo


func _init(new_player := Player.new(), new_properties := {}):
	player = new_player
	set_props_from_dict(new_properties)
	# must wait for tree to finish setting up children
	player.get_tree().root.add_child.call_deferred(reload_timer)
	bullets_node = player.get_tree().root.get_node(^"/root/Game/Bullets")


func set_props_from_dict(new_properties := {}):
	for key in new_properties:
		set_prop(key, new_properties[key])
	current_ammo = properties.max_ammo


func fire():
	if firing or current_ammo <= 0 or reloading:
		return
	firing = true
	current_ammo -= 1
	spawn_bullets()
	await wait_fire_rate()
	firing = false
	begin_reload_delay()


func create_bullet() -> Bullet:
	var bullet = BulletNode.instantiate() as Bullet
	bullet.speed = properties.bullet_speed
	bullet.damage = properties.damage
	bullet.bullet_range = properties.bullet_range
	bullet.position = player.position - player.look_vector.normalized() * player.sprite.texture.get_width()
	bullet.rotation = player.sprite.rotation
	return bullet


func spawn_bullets():
	var bullet = create_bullet()
	bullets_node.add_child(bullet)


func wait_fire_rate():
	# reciprocal of fire_rate = seconds per bullet
	await player.get_tree().create_timer(1.0 / properties.fire_rate).timeout


func reload():
	if delaying_reload:
		return
	reloading = true
	reload_timer.start(properties.reload_speed)
	await reload_timer.timeout
	if not reload_timer.is_stopped():
		current_ammo = properties.max_ammo
	reloading = false


func interrupt_reload():
	reload_timer.stop()
	reload_timer.timeout.emit()


func begin_reload_delay():
	delaying_reload = true
	await player.get_tree().create_timer(properties.reload_delay).timeout
	delaying_reload = false


func get_prop(property_name : String) -> Variant:
	return properties[property_name]


func set_prop(property_name : String, value : Variant):
	if properties.has(property_name):
		properties[property_name] = value


func _get(property: StringName) -> Variant:
	if properties.has(property):
		return properties[property]
	return super._get(property)
	

func _set(property: StringName, value: Variant) -> bool:
	if properties.has(property):
		properties[property] = value
		return true
	return super._set(property, value)


func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.ANY
