class_name Rifle
extends Weapon


func _init(new_player : Player = null, new_properties := {}):
	_add_default_properties({
			bullet_range = 1000,
			bullet_speed = 2000,
			fire_rate = 1,
			max_ammo = 5,
			reload_speed = 1,
			piercing = true,
	})
	super._init(new_player, new_properties)


func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.RIFLE
