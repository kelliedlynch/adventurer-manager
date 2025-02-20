@tool
extends Control
class_name ReactiveField

var linked_model: Object = null
var linked_class: StringName = ""
var linked_property: StringName = ""

func _get(property):
	# This is solely to allow updating linked class and property in the editor
	if property.begins_with("__test"):
		return get_test_value(property)
	if property.begins_with("__") and property.right(-2) in self:
		return get(property.right(-2))
		
func get_test_value(property: StringName):
	pass

func _set(property, value):
	# This is solely to allow updating linked class and property in the editor
	#print(property, " current value ", value, " revert value ", _property_get_revert(property))
	if property.begins_with("__test"):
		set_test_value(property, value)
		return true
	if property.begins_with("__") and property.right(-2) in self:
		set(property.right(-2), value)
		notify_property_list_changed()
		return true
	return false
	
func set_test_value(property: StringName, value: Variant):
	pass

func clear_test_value():
	pass
	
func _property_can_revert(property: StringName) -> bool:
	if property.begins_with("__test"):
		return get(property) != _property_get_revert(property)
	if property == "__linked_class":
		return linked_class != _property_get_revert("__linked_class")
	if property == "__linked_property":
		return linked_property != _property_get_revert("__linked_property")
	return false
	
func _property_get_revert(property: StringName) -> Variant:
	if property == "__linked_class":
		return ""
	if property == "__linked_property":
		return ""
	return false

func _get_property_list() -> Array:
	# Everything here is solely for updating the view in the editor. Do not use double underscore
	# properties in scripts.
	var props = []
	if not Engine.is_editor_hint(): return props
	var custom_classes = ProjectSettings.get_global_class_list()
	props.append({
		name = "__linked_class",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = custom_classes.reduce(func(accum, val): return accum + val.class + ",", "").left(-1)
	})
	if linked_class:
		props.append({
			name = "__linked_property",
			type = TYPE_STRING_NAME,
			hint = PROPERTY_HINT_ENUM,
			hint_string = get_property_hint_string()
		})
	return props
	
func get_property_hint_string() -> String:
	if not linked_class:
		return ""
	var instance = Utility.instance_class_from_string_name(linked_class)
	var props = instance.get_property_list().map(func(x): return x.name)
	return Utility.array_to_hint_string(props)

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		clear_test_value()
