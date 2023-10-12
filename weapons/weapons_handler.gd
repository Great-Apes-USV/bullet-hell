extends Node

enum FireMode {SEMI, FULL}
enum WeaponType {ANY, PISTOL, SHOTGUN, RIFLE, SMG}

func weapon_from_type(weapon_type : Weapons.WeaponType) -> Object:
	match weapon_type:
		WeaponType.PISTOL:
			return Pistol
		WeaponType.SHOTGUN:
			return Shotgun
		WeaponType.RIFLE:
			return Rifle
		WeaponType.SMG:
			return SMG
		_:
			return Weapon
