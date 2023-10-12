class_name Player
extends Entity

const MAX_CASH = 999

@export var speed : float = 300
@export var roll_distance : float = 200
@export var roll_duration : float = 0.3
@onready var roll_speed : float = roll_distance / roll_duration

@export var weapon_type : Weapons.WeaponType = Weapons.WeaponType.ANY

@export var cash_balance : int = 0;

@onready var sprite : Sprite2D = $Sprite2D

var weapon : Weapon

var move_vector : Vector2 = Vector2.ZERO
var look_vector : Vector2 = Vector2.ZERO
var roll_vector : Vector2 = Vector2.ZERO

var rolling : bool = false
var reloading : bool:
	get: return weapon.reloading
var needs_reload : bool:
	get: return weapon.needs_reload

func _ready():
	var weapon_properties : Dictionary = {
		bullet_range = 250,
		bullet_speed = 750,
		fire_rate = 3,
		magazine_size = 2,
		reload_speed = 0.75
	}
	weapon = Weapons.weapon_from_type(weapon_type).new(self, weapon_properties)

func _process(_delta):
	sprite.look_at(get_global_mouse_position())
	# respects circular deadzone
	move_vector = Input.get_vector("move-left", "move-right", "move-up", "move-down")
	look_vector = -Vector2.from_angle(sprite.rotation)
	
	%TempPlayerHealthLabel.text = "%d HP" % health
	%TempWeaponAmmoLabel.text = "%d/%d Ammo" % [weapon.current_magazine, weapon.magazine_size]
	
	if weapon.fire_mode == Weapons.FireMode.SEMI:
		if Input.is_action_just_pressed("fire"):
			fire()
	elif weapon.fire_mode == Weapons.FireMode.FULL:
		if Input.is_action_pressed("fire"):
			fire()
	
	if Input.is_action_just_pressed("roll"):
		roll()
	
	if Input.is_action_just_pressed("reload"):
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
	weapon.interrupt_reload()
	roll_vector = move_vector
	collision_mask = 1|64
	if roll_vector == Vector2.ZERO:
		roll_vector = look_vector
	await get_tree().create_timer(roll_duration).timeout
	collision_mask = 1|16|32|64
	rolling = false

func fire():
	if needs_reload and not reloading:
		reload()
		return
	if rolling:
		return
	weapon.fire()

func reload():
	if rolling:
		return
	%TempReloadingLabel.show()
	await weapon.reload()
	%TempReloadingLabel.hide()

func change_balance(amount) -> bool:
	cash_balance += amount;
	if(cash_balance < 0):
		cash_balance -= amount
		return false
	if(cash_balance >= MAX_CASH):
		cash_balance = MAX_CASH;
	return true
