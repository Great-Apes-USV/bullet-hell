extends CharacterBody2D

@export var speed : float = 200
@export var roll_distance : float = 75
@export var roll_duration : float = 0.2
@onready var roll_speed : float = roll_distance / roll_duration
@export var bal = 0;
const MAX_BAL = 999

@onready var sprite = $Sprite2D

var move_vector : Vector2 = Vector2.ZERO
var look_vector : Vector2 = Vector2.ZERO
var roll_vector : Vector2 = Vector2.ZERO

var rolling = false

func _ready():
	pass

@warning_ignore("unused_parameter")
func _process(delta):
	sprite.look_at(get_global_mouse_position())
	# respects circular deadzone
	move_vector = Input.get_vector("move-left", "move-right", "move-up", "move-down")
	look_vector = -Vector2.from_angle(sprite.rotation)
	
	if Input.is_action_just_pressed("fire"):
		fire()
	if Input.is_action_just_pressed("roll") and not rolling:
		roll()

@warning_ignore("unused_parameter")
func _physics_process(delta):
	velocity = move_vector * speed
	if rolling:
		velocity = roll_vector * roll_speed
	move_and_slide()

func roll():
	roll_vector = move_vector
	collision_mask = 1|6
	if roll_vector == Vector2.ZERO:
		roll_vector = look_vector
	rolling = true
	await get_tree().create_timer(roll_duration).timeout
	rolling = false
	collision_mask = 1|4|5|6

func fire():
	pass


#Money system code:
#Returns bool true if balance > 0, and false if bal < 0 declining a purchase. 
#Parameter: Amount you want to change. Use negative amts for purchases
func changeBal(amt) -> bool:
	bal += amt;
	if(bal < 0):
		bal -=amt
		return false
	if(bal >= MAX_BAL):
		bal = MAX_BAL;
	return true

func getBal() -> int:
	return bal;
