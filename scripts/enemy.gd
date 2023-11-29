class_name Enemy
extends Entity


@export var damage : int = 5

var player : Player
var overhealthNode : PackedScene = preload("res://Drops/overhealth.tscn")
var enemy : Enemy

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var drops_node : Node2D = get_tree().root.get_node(^"/root/Game/Drops")


func _init(new_player : Player = null):
	player = new_player


func _ready():
	nav_agent.velocity_computed.connect(_on_velocity_computed)

func drop_item():
	var drop_rate = randi() % (100 + 1 - 1) + 1
	if drop_rate < 21:
		var item_select = randi() % (10 + 1 - 1) + 1
		if item_select <= 4:
			print("dropped regen") #drop regen
		elif item_select >= 5 or item_select <= 7:
			print("dropped overhealth") 
			spawn_overhealth()
		else:
			print("dropped stim") #drop stim
	else:
		pass

func die():
	drop_item()
	queue_free()

func _physics_process(delta):
	if player:
		look_at(player.global_position)
		nav_agent.target_position = player.global_position
		var current_location : Vector2 = global_position
		var next_location : Vector2 = nav_agent.get_next_path_position()
		var direction : Vector2 = (next_location - current_location).normalized()
		nav_agent.velocity = direction * speed

		var collision : KinematicCollision2D = move_and_collide(velocity.normalized() * speed * delta)
		if collision and collision.get_collider() == player:
			player.take_damage(damage)
			die()

func create_overhealth():
	var overhealth = overhealthNode.instantiate() as Overhealth
	overhealth.position = position
	return overhealth


func spawn_overhealth():
	var overhealth = create_overhealth()
	drops_node.add_child(overhealth)


func _on_velocity_computed(safe_velocity : Vector2):
	velocity = safe_velocity
