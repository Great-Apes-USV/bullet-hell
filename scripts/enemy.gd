class_name Enemy
extends Entity


@export var damage : int = 5

var player : Player

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D


func _init(new_player : Player = null):
	player = new_player


func _ready():
	nav_agent.velocity_computed.connect(_on_velocity_computed)


func _physics_process(delta):
	if player:
		$SpriteRotator.look_at(player.global_position)
		set_sprite_from_rotation($AnimatedSprite2D, $SpriteRotator.rotation)
		nav_agent.target_position = player.global_position
		var current_location : Vector2 = global_position
		var next_location : Vector2 = nav_agent.get_next_path_position()
		var direction : Vector2 = (next_location - current_location).normalized()
		nav_agent.velocity = direction * speed

		var collision : KinematicCollision2D = move_and_collide(velocity.normalized() * speed * delta)
		if collision and collision.get_collider() == player:
			player.take_damage(damage)
			die()


func _on_velocity_computed(safe_velocity : Vector2):
	velocity = safe_velocity


func die():
	if GameHandler.enemies.get_children().size() <= 1:
		GameHandler.world.clear_room()
	super.die()
