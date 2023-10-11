class_name Player
extends CharacterBody2D

@export var speed : float = 200
@export var roll_distance : float = 75
@export var roll_duration : float = 0.2
@onready var roll_speed : float = roll_distance / roll_duration

@onready var sprite = $Sprite2D
@onready var weapon = Shotgun.new(self)

var move_vector : Vector2 = Vector2.ZERO
var look_vector : Vector2 = Vector2.ZERO
var roll_vector : Vector2 = Vector2.ZERO

var rolling = false

func _ready():
	weapon.range = 250
	weapon.bullet_speed = 750
	weapon.fire_rate = 3
	weapon.magazine_size = 2
	weapon.current_magazine = weapon.magazine_size

func _process(_delta):
	sprite.look_at(get_global_mouse_position())
	# respects circular deadzone
	move_vector = Input.get_vector("move-left", "move-right", "move-up", "move-down")
	look_vector = -Vector2.from_angle(sprite.rotation)
	
	if weapon.fire_mode == Weapons.FireMode.SEMI:
		if Input.is_action_just_pressed("fire"):
			fire()
	elif weapon.fire_mode == Weapons.FireMode.FULL:
		if Input.is_action_pressed("fire"):
			fire()
	
	if Input.is_action_just_pressed("roll") and not rolling:
		roll()
	
	if Input.is_action_just_pressed("reload"):
		reload()

func _physics_process(_delta):
	velocity = move_vector * speed
	if rolling:
		velocity = roll_vector * roll_speed
	move_and_slide()

func roll():
	roll_vector = move_vector
	collision_mask = 1|64
	if roll_vector == Vector2.ZERO:
		roll_vector = look_vector
	rolling = true
	await get_tree().create_timer(roll_duration).timeout
	rolling = false
	collision_mask = 1|16|32|64

func fire():
	if weapon.needs_reload and not weapon.reloading:
		reload()
		return
	weapon.fire()

func reload():
	%TempReloadingLabel.show()
	await weapon.reload()
	%TempReloadingLabel.hide()
