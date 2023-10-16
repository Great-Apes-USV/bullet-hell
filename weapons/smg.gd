class_name SMG
extends Weapon

@export var spread_angle : float = 20

func set_props_from_dict(new_properties := {}):
	if new_properties == {}:
		new_properties = {
			bullet_range = 1000,
			bullet_speed = 1000,
			fire_rate = 10,
			max_ammo = 100,
			reload_speed = 0.75,
		}
	super.set_props_from_dict(new_properties)

func spawn_bullets():
		var bullet_rotation : float = lerp(spread_angle * 0.5, -spread_angle * 0.5, randf())
		var bullet = create_bullet()
		bullet.rotation += deg_to_rad(bullet_rotation)
		bullets_node.add_child(bullet)

func rand(_delta) -> float:
	return _delta

func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.SMG
