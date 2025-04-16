class_name Pistol
extends Weapon


func _init(new_player : Player = null, new_properties := {}):
	_add_default_properties({})
	super._init(new_player, new_properties)


func _get_type() -> Weapons.WeaponType:
	return Weapons.WeaponType.PISTOL
