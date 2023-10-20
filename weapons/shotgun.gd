class_name Shotgun
extends Weapon


func _get_class_defaults() -> Dictionary:
	var class_defaults := {
			bullet_range = 250,
			bullet_speed = 750,
			fire_rate = 3,
			max_ammo = 2,
			reload_speed = 0.75,
			spread_angle = 30,
			bullet_count = 5,
			slug = false,
	}
	return class_defaults


func _add_class_defaults():
	var class_defaults : Dictionary = _get_class_defaults()
	class_defaults.merge(super._get_class_defaults())
	properties.merge(class_defaults)


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
