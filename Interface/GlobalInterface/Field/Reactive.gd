@tool
extends Control
class_name Reactive
# Base class for a control node that updates in response to changes in a linked object

var linked_object: Variant = null
var linked_class: StringName = ""

func update_from_linked_object():
	pass

func _process(_delta: float) -> void:
	#if linked_object:
	update_from_linked_object()
	
func _get_property_list() -> Array:
	var props = []
	if not Engine.is_editor_hint(): return props
	var custom_classes = get_linkable_object_classes()
	props.append({
		name = "__linked_class",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = custom_classes.reduce(func(accum, val): return accum + val.class + ",", "").left(-1)
	})
	return props

func link_object(obj: Variant, node: Node = self):
	if node is Reactive and node.linked_class and (not obj or Utility.is_derived_from(obj.get_script().get_global_name(), node.linked_class)):
		node.linked_object = obj
	for child in node.get_children():
		link_object(obj, child)

func get_linkable_object_classes():
	return ProjectSettings.get_global_class_list()
	
func _get(property):
	# This is solely to allow updating linked class and property in the editor
	if property.begins_with("__test"):
		return get_test_value(property)
	if property.begins_with("__") and property.right(-2) in self:
		return get(property.right(-2))
		
func get_test_value(_property: StringName):
	pass
	
func set_test_value(_property: StringName, value: Variant):
	pass
	
func clear_test_value():
	pass

func _set(property, value):
	# This is solely to allow updating linked class and property in the editor
	if property.begins_with("__test"):
		set_test_value(property, value)
		return true
	if property.begins_with("__") and property.right(-2) in self:
		set(property.right(-2), value)
		notify_property_list_changed()
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	if property == "__linked_class":
		return ""
	return false

func _property_can_revert(property: StringName) -> bool:
	if property.begins_with("__test"):
		return get(property) != _property_get_revert(property)
	if property == "__linked_class":
		return linked_class != _property_get_revert("__linked_class")
	return false

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		clear_test_value()
