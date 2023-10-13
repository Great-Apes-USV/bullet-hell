extends Node

enum FireMode {SEMI, FULL}
enum WeaponType {ANY, PISTOL, SHOTGUN, RIFLE, SMG}

func weapon_from_type(weapon_type : Weapons.WeaponType) -> GDScript:
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

func new_preset_weapon(player : Player, preset_name : String = "") -> Weapon:
	var weapon_script : GDScript = Weapon
	var preset_strings : PackedStringArray = preset_name.split("_")
	var new_weapon : Weapon
	if WeaponType.has(preset_strings[-1].to_upper()):
		weapon_script = weapon_from_type(WeaponType.get(preset_strings[-1].to_upper()))
	new_weapon = weapon_script.new(player)
	if "full" in preset_strings:
		new_weapon.fire_mode = FireMode.FULL
	if "extended" in preset_strings:
		new_weapon.max_ammo *= 2
		new_weapon.current_ammo = new_weapon.max_ammo
	
	return new_weapon
