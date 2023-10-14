class_name Player
extends Entity

const MAX_CASH = 999
const MAX_WEAPONS = 2

@export var speed : float = 300
@export var roll_distance : float = 200
@export var roll_duration : float = 0.3
@onready var roll_speed : float = roll_distance / roll_duration

@export var autoreload : bool = true

@export var cash_balance : int = 0;

@onready var sprite : Sprite2D = $Sprite2D

var weapons : Array[Weapon] = []
var current_weapon_num : int = 0:
	set(value):
		if value >= MAX_WEAPONS or value >= weapons.size():
			current_weapon_num = 0
		else:
			current_weapon_num = value
var current_weapon : Weapon:
	get: return weapons[current_weapon_num]

var move_vector : Vector2 = Vector2.ZERO
var look_vector : Vector2 = Vector2.ZERO
var roll_vector : Vector2 = Vector2.ZERO

var rolling : bool = false
var reloading : bool:
	get: return current_weapon.reloading

func _ready():
	add_preset_weapon("full_rapid_lightweight_pistol")
	add_preset_weapon("full_magnum_slug_shotgun")

func _process(_delta):
	sprite.look_at(get_global_mouse_position())
	# respects circular deadzone
	move_vector = Input.get_vector("move-left", "move-right", "move-up", "move-down")
	look_vector = -Vector2.from_angle(sprite.rotation)
	
	%TempPlayerHealthLabel.text = "%d HP" % health
	%TempWeaponAmmoLabel.text = "%d/%d Ammo" % [current_weapon.current_ammo, current_weapon.max_ammo]
	
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
	
	if autoreload and current_weapon.no_ammo:
		reload()

func _physics_process(_delta):
	velocity = move_vector * speed
	if rolling:
		velocity = roll_vector * roll_speed
	move_and_slide()

func roll():
	if rolling:
		return
	
	rolling = true
	current_weapon.interrupt_reload()
	roll_vector = move_vector
	collision_mask = 1|64
	if roll_vector == Vector2.ZERO:
		roll_vector = look_vector
	await get_tree().create_timer(roll_duration).timeout
	collision_mask = 1|16|32|64
	rolling = false

func fire():
	if current_weapon.no_ammo and not reloading:
		reload()
		return
	if rolling:
		return
	current_weapon.fire()

func reload():
	if rolling or current_weapon.current_ammo == current_weapon.max_ammo or reloading or current_weapon.firing:
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

func change_balance(amount) -> bool:
	cash_balance += amount;
	if(cash_balance < 0):
		cash_balance -= amount
		return false
	if(cash_balance >= MAX_CASH):
		cash_balance = MAX_CASH;
	return true
