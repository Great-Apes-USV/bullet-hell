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


func new_preset_weapon(player : Player, preset_name := "") -> Weapon:
	var weapon_script : GDScript = Weapon
	var preset_strings : PackedStringArray = preset_name.split("_")
	var new_weapon : Weapon
	
	if WeaponType.has(preset_strings[-1].to_upper()):
		weapon_script = weapon_from_type(WeaponType.get(preset_strings[-1].to_upper()))
	
	new_weapon = weapon_script.new(player)
	new_weapon.preset_name = preset_name
	
	for keyword in preset_strings:
		if keyword == "tight" and new_weapon is Shotgun:
			new_weapon.spread_angle *= 0.5
		
		if keyword == "slug" and new_weapon is Shotgun:
			new_weapon.slug = true
		
		match keyword:
			"full":
				new_weapon.fire_mode = FireMode.FULL
			"semi":
				new_weapon.fire_mode = FireMode.SEMI
			"extended":
				new_weapon.max_ammo *= 2
				new_weapon.current_ammo = new_weapon.max_ammo
			"rapid":
				new_weapon.fire_rate *= 2
			"ranged":
				new_weapon.bullet_range *= 2
			"magnum":
				new_weapon.bullet_range *= 1.5
				new_weapon.damage *= 1.5
				new_weapon.bullet_speed *= 1.5
			"lightweight":
				new_weapon.reload_speed /= 2
	
	return new_weapon
