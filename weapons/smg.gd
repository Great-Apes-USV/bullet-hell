class_name SMG
extends Weapon


func _init(new_player : Player = null, new_properties := {}):
	_add_default_properties({
			bullet_range = 500,
			bullet_speed = 1000,
			fire_rate = 10,
			max_ammo = 100,
			reload_speed = 0.75,
			spread_angle = 20,
	})
	super._init(new_player, new_properties)


func spawn_bullets():
		var half_spread = properties.spread_angle * 0.5
		var bullet_rotation : float = lerp(half_spread, -half_spread, randf())
		var bullet = create_bullet()
		bullet.rotation += deg_to_rad(bullet_rotation)
		bullets_node.add_child(bullet)


func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.SMG
