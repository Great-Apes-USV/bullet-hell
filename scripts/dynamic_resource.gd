@tool
class_name DynamicResource
extends Resource


@export var properties := {}


func assign_default_properties():
	properties = {}


func add_default_properties(default_properties := {}):
	properties.merge(default_properties)


func set_props_from_dict(new_properties := {}):
	for key in new_properties:
		set_prop(key, new_properties[key])


func get_prop(property_name : String) -> Variant:
	return properties[property_name]


func set_prop(property_name : String, value : Variant):
	if properties.has(property_name):
		properties[property_name] = value


func _get(property: StringName) -> Variant:
	if properties.has(property):
		return properties[property]
	return null

func _set(property: StringName, value: Variant) -> bool:
	if properties.has(property):
		properties[property] = value
		return true
	return false
