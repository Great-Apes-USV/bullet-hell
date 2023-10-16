class_name DynamicObject
extends Object


@export var override_default_set = true
@export var properties := {}


func _assign_default_properties():
	properties = {}


func _add_default_properties(default_properties := {}):
	properties.merge(default_properties)


func set_props_from_dict(new_properties := {}):
	for key in new_properties:
		_set(key, new_properties[key])


func _get(property: StringName) -> Variant:
	if properties.has(property):
		return properties[property]
	return null


func _set(property: StringName, value: Variant) -> bool:
	if properties.has(property):
		properties[property] = value
		return override_default_set
	return false
