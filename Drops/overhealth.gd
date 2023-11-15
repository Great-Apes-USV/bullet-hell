extends Node

var MAX_LIFETIME : int = 10
var drops_node : Node2D
var overhealthNode : PackedScene = preload("res://Drops/overhealth.tscn")#this is where I left off

static var overhealth_id

func _enter_tree():
	name = "Overhealth_%d" % overhealth_id
	overhealth_id += 1 
	die_after_seconds(MAX_LIFETIME)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func die_after_seconds(seconds : float):
	await get_tree().create_timer(seconds).timeout
	die()

func die():
	queue_free()
