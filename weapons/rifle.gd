class_name Rifle
extends Weapon


func set_props_from_dict(new_properties := {}):
	if new_properties == {}:
		new_properties = {
			bullet_range = 1000,
			bullet_speed = 2000,
			fire_rate = 1,
			max_ammo = 5,
			reload_speed = 1,
			piercing = true,
		}
	super.set_props_from_dict(new_properties)

func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.RIFLE
