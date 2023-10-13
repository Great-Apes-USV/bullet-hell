class_name Shotgun
extends Weapon

@export var spread_angle : float = 30
@export var bullet_count : int = 5

func set_props_from_dict(properties : Dictionary = {}, is_new_weapon : bool = false):
	if properties == {}:
		properties = {
			bullet_range = 250,
			bullet_speed = 750,
			fire_rate = 3,
			max_ammo = 2,
			reload_speed = 0.75
		}
	super.set_props_from_dict(properties, is_new_weapon)
	if properties.has("spread_angle"):
		spread_angle = properties.spread_angle
	if properties.has("bullet_count"):
		bullet_count = properties.bullet_count

func spawn_bullets():
	for i in range(bullet_count):
		var bullet_rotation : float = lerp(spread_angle * 0.5, -spread_angle * 0.5, float(i) / (bullet_count - 1))
		var bullet = create_bullet()
		bullet.rotation += deg_to_rad(bullet_rotation)
		bullets_node.add_child(bullet)

func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.SHOTGUN
