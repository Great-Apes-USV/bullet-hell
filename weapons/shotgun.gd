class_name Shotgun
extends Weapon


func _init(new_player : Player = null, new_properties := {}):
	_add_default_properties({
			bullet_range = 250,
			bullet_speed = 750,
			fire_rate = 3,
			max_ammo = 2,
			reload_speed = 0.75,
			spread_angle = 30,
			bullet_count = 5,
			slug = false,
	})
	super._init(new_player, new_properties)


func spawn_bullets():
	if properties.slug:
		var bullet = create_bullet()
		bullet.rescale(Vector2(2, 1))
		bullets_node.add_child(bullet)
		return
	for i in range(properties.bullet_count):
		var half_spread = properties.spread_angle * 0.5
		var lerp_weight = float(i) / (properties.bullet_count - 1)
		var bullet_rotation : float = lerp(half_spread, -half_spread, lerp_weight)
		var bullet = create_bullet()
		bullet.rotation += deg_to_rad(bullet_rotation)
		bullets_node.add_child(bullet)


func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.SHOTGUN
