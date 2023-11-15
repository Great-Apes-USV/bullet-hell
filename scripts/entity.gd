class_name Entity
extends CharacterBody2D


@export var max_health : int = 100
@export var speed : float = 300

var health : int = max_health


func take_damage(amount : int):
	health -= amount
	if health <= 0:
		die()


func heal(amount : int):
	health += amount
	if health > max_health:
		health = max_health


func die():
	queue_free()


func set_sprite_from_rotation(animated_sprite: AnimatedSprite2D, sprite_rotation: float):
	var sprite_angle : float = fposmod(rad_to_deg(sprite_rotation), 360) + 22.5
	if sprite_angle < 45:
		animated_sprite.frame = 0
	elif sprite_angle >= 45 and sprite_angle < 90:
		animated_sprite.frame = 1
	elif sprite_angle >= 90 and sprite_angle < 135:
		animated_sprite.frame = 2
	elif sprite_angle >= 135 and sprite_angle < 180:
		animated_sprite.frame = 3
	elif sprite_angle >= 180 and sprite_angle < 225:
		animated_sprite.frame = 4
	elif sprite_angle >= 225 and sprite_angle < 270:
		animated_sprite.frame = 5
	elif sprite_angle >= 270 and sprite_angle < 315:
		animated_sprite.frame = 6
	elif sprite_angle >= 315:
		animated_sprite.frame = 7
