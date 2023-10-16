class_name Shotgun
extends Weapon


@export var spread_angle : float = 30
@export var bullet_count : int = 5
@export var slug := false


func set_props_from_dict(new_properties := {}):
	if new_properties == {}:
		new_properties = {
			bullet_range = 250,
			bullet_speed = 750,
			fire_rate = 3,
			max_ammo = 2,
			reload_speed = 0.75,
		}
	super.set_props_from_dict(new_properties)


func spawn_bullets():
	if slug:
		var bullet = create_bullet()
		bullet.rescale(Vector2(2, 1))
		bullets_node.add_child(bullet)
		return
	for i in range(bullet_count):
		var bullet_rotation : float = lerp(spread_angle * 0.5, -spread_angle * 0.5, float(i) / (bullet_count - 1))
		var bullet = create_bullet()
		bullet.rotation += deg_to_rad(bullet_rotation)
		bullets_node.add_child(bullet)


func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.SHOTGUN
