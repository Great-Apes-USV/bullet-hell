@icon("ldtk-level.svg")
@tool
class_name LDTKLevel
extends Node2D


@export var size: Vector2i
@export var fields: Dictionary
@export var neighbours: Array
@export var bg_color: Color

var pitfalls: Area2D
var pitfallShapes: Array[Rect2]

func _ready() -> void:
	if has_node("PitfallArea2D"):
		pitfalls = $PitfallArea2D
		for child in pitfalls.get_children():
			if child is CollisionShape2D:
				var pitfallShape: Rect2 = child.shape.get_rect()
				pitfallShape.position += child.position
				pitfallShapes.append(pitfallShape)
	queue_redraw()


func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO, size), bg_color, false, 2.0)


func _physics_process(_delta):
	if not pitfalls:
		return
	
	for body in pitfalls.get_overlapping_bodies():
		if not body is Entity:
			return
		for collider in body.get_children(true):
			if not collider is CollisionShape2D:
				return
			for pitfallShape in pitfallShapes:
				var colliderRect: Rect2 = collider.shape.get_rect()
				colliderRect.position += body.position
				if pitfallShape.encloses(colliderRect):
					body.die()
