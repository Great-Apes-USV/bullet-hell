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
	pass
