class_name Player
extends Entity


const MAX_CASH : int = 999
const MAX_WEAPONS : int = 2

@export var roll_distance : float = 200
@export var roll_duration := 0.3
@export var autoreload := true
@export var cash_balance : int = 0
@export var max_stamina : float = 100
@export var stamina_cost : float = 20
@export var stamina_regeneration_rate : float = 10
@export var stamina_regeneration_delay : float = 0.5

var move_vector := Vector2.ZERO
var look_vector := Vector2.ZERO
var roll_vector := Vector2.ZERO
var roll_speed : float = roll_distance / roll_duration
var rolling := false
var just_rolled := false
var weapons : Array[Weapon] = []
var current_weapon_num : int = 0:
	set(value):
		current_weapon_num = 0 if value >= MAX_WEAPONS or value >= weapons.size() else value
var current_weapon : Weapon:
	get: return weapons[current_weapon_num]
var reloading : bool:
	get: return current_weapon.reloading
var current_stamina : float = max_stamina
var stamina_regeneration_delay_timer := Timer.new()

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_angle : Node2D = $PlayerAngle
@onready var sprite_width : float = sprite.sprite_frames.get_frame_texture("default", 0).get_width()


func _ready():
	add_child(stamina_regeneration_delay_timer)
	#add_preset_weapon("full_rapid_lightweight_pistol")
	add_preset_weapon("rapid_lightweight_ricochet_smg")
	#add_preset_weapon("semi_magnum_rifle")
	#add_preset_weapon("semi_magnum_pistol")
	add_preset_weapon("full_ricochet_rifle")


func _process(_delta):
	player_angle.look_at(get_global_mouse_position())
	var sprite_angle : float = fposmod(rad_to_deg(player_angle.rotation), 360) + 22.5
	if sprite_angle < 45:
		sprite.frame = 0
	elif sprite_angle >= 45 and sprite_angle < 90:
		sprite.frame = 1
	elif sprite_angle >= 90 and sprite_angle < 135:
		sprite.frame = 2
	elif sprite_angle >= 135 and sprite_angle < 180:
		sprite.frame = 3
	elif sprite_angle >= 180 and sprite_angle < 225:
		sprite.frame = 4
	elif sprite_angle >= 225 and sprite_angle < 270:
		sprite.frame = 5
	elif sprite_angle >= 270 and sprite_angle < 315:
		sprite.frame = 6
	elif sprite_angle >= 315:
		sprite.frame = 7
	# respects circular deadzone
	move_vector = Input.get_vector("move-left", "move-right", "move-up", "move-down")
	look_vector = -Vector2.from_angle(player_angle.rotation)
	
	%TempPlayerHealthLabel.text = "%d HP" % health
	%TempWeaponAmmoLabel.text = "%d/%d Ammo" % [current_weapon.current_ammo, current_weapon.max_ammo]
	%TempStaminaLabel.text = "%d Stam" % current_stamina
	
	if current_weapon.fire_mode == Weapons.FireMode.SEMI:
		if Input.is_action_just_pressed("fire"):
			fire()
	elif current_weapon.fire_mode == Weapons.FireMode.FULL:
		if Input.is_action_pressed("fire"):
			fire()
	
	if Input.is_action_just_pressed("roll"):
		roll()
	
	if Input.is_action_just_pressed("reload"):
		reload()
	
	if Input.is_action_just_pressed("weapon-swap"):
		swap_weapon()
	
	if Input.is_action_just_pressed("debug-spawn-enemy"):
		debug_spawn_enemy()
	
	if autoreload and current_weapon.no_ammo:
		reload()


func _physics_process(delta):
	velocity = move_vector * speed if not rolling else roll_vector * roll_speed
	move_and_slide()
	regenerate_stamina(delta) 


func roll():
	if rolling or current_stamina < stamina_cost:
		return
	
	rolling = true
	current_weapon.interrupt_reload()
	collision_mask = 1|64
	collision_layer = 0
	roll_vector = look_vector if move_vector == Vector2.ZERO else move_vector
	await get_tree().create_timer(roll_duration).timeout
	collision_mask = 1|16|32|64
	collision_layer = 2
	current_stamina -= stamina_cost #adjustable stamina cost for rolling
	stamina_regeneration_delay_timer.start(stamina_regeneration_delay)
	just_rolled = true
	rolling = false


func fire():
	if current_weapon.no_ammo and not reloading:
		reload()
		return
	
	if rolling:
		return
	
	current_weapon.fire()


func reload():
	if rolling or current_weapon.full_ammo or reloading:
		return
	
	%TempReloadingLabel.show()
	await current_weapon.reload()
	%TempReloadingLabel.hide()


func add_preset_weapon(new_weapon_name : String):
	add_weapon(Weapons.new_preset_weapon(self, new_weapon_name))


func add_weapon(new_weapon : Weapon):
	if weapons.size() < MAX_WEAPONS:
		weapons.push_back(new_weapon)
		current_weapon_num += 1
	else:
		weapons[current_weapon_num] = new_weapon


func swap_weapon():
	current_weapon.interrupt_reload()
	current_weapon_num += 1


func change_balance(amount : int) -> bool:
	cash_balance += amount;
	if(cash_balance < 0):
		cash_balance -= amount
		return false
	
	if(cash_balance >= MAX_CASH):
		cash_balance = MAX_CASH;
	
	return true


func debug_spawn_enemy():
	var enemy = preload("res://characters/enemy.tscn").instantiate()
	enemy.position = get_global_mouse_position() - (Vector2($/root/Game.gap) / 2)
	enemy.player = self
	$/root/Game/Enemies.add_child(enemy)

func regenerate_stamina(delta: float):
	if just_rolled:
		await stamina_regeneration_delay_timer.timeout
		just_rolled = false
	elif not rolling and current_stamina < max_stamina:
		current_stamina += stamina_regeneration_rate * delta
		current_stamina = min(current_stamina, max_stamina)
		current_stamina = max(current_stamina, 0)
