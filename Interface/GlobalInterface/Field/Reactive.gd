@tool
extends Control
## Base class for a control node that updates in response to changes in a linked object. Can optionally
## have a linked property to watch
class_name Reactive

var linked_object: Variant = null
var linked_class: StringName = ""
var linked_property: StringName = ""
var array_object_type: StringName = ""

## Override if this Reactive needs to react to any non-Observable properties changing
func update_from_linked_object():
	pass

func _process(_delta: float) -> void:
	update_from_linked_object()
	
func _get_property_list() -> Array:
	var props = []
	if not Engine.is_editor_hint(): return props
	props.append({
		name = "__linked_class",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = _get_linkable_class_hint_string()
	})
	if linked_class:
		props.append({
			name = "__linked_property",
			type = TYPE_STRING_NAME,
			hint = PROPERTY_HINT_ENUM,
			hint_string = _get_linkable_property_hint_string()
		})
		if linked_class == "ObservableArray":
			props.append({
			name = "__array_object_type",
			type = TYPE_STRING_NAME,
			hint = PROPERTY_HINT_ENUM,
			hint_string = _get_linkable_class_hint_string()
		})
	return props

## Watches an object for changes. If recursive, tree will be searched downward and also connect Reactive children.
## Override if linking an object means Reactive children will need to react to different objects or properties than this Reactive does
## If you do not need to pass the linked object down to child objects, do not call super in the override
## Maybe this shouldn't be recursive at all, and I should deal individually with Reactive objects with children
func link_object(obj: Variant, node: Node = self, recursive = false):
	if obj and node is Reactive:
		if node.linked_class and Utility.is_derived_from(obj.get_script().get_global_name(), node.linked_class):
			node.linked_object = obj
			#if "array_type" in obj:
				#var a = str(obj.array_type.get_global_name())
				#var b = array_object_type
			if obj is ObservableArray and (not array_object_type or array_object_type == str(obj.array_type.get_global_name())):
				obj.array_changed.connect(node._on_linked_observable_object_changed.bind(obj))
				node._on_linked_observable_object_changed(obj)
			if linked_property and linked_property in obj and obj.get(linked_property) is ObservableArray:
				obj.get(linked_property).array_changed.connect(node._on_linked_observable_property_changed.bind(obj.get(linked_property)))
				node._on_linked_observable_object_changed(obj.get(linked_property))
	if recursive:
		for child in node.get_children():
			link_object(obj, child, recursive)
		
## Override to react to contents of a linked_object ObservableArray changing. 
func _on_linked_observable_object_changed(obj: ObservableArray):
	pass
	
## Override to react to contents of an ObservableArray property of linked_object changing
func _on_linked_observable_property_changed(obj: ObservableArray):
	pass
		
func unlink_object(obj: Variant, node: Node = self, recursive = false):
	if node is Reactive and node.linked_object == obj:
		node.linked_object = null
	if recursive:
		for child in node.get_children():
			unlink_object(obj, child, recursive)
	
func _get(property):
	# This is solely to allow updating linked class and property in the editor
	if property.begins_with("__test"):
		#print("getting test value in base for ", property)
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
		("set test value in base")
		set_test_value(property, value)
		return true
	if property.begins_with("__") and property.right(-2) in self:
		("set called, but didn't catch test value")
		set(property.right(-2), value)
		notify_property_list_changed()
		return true
	return false
	
## Override to filter the list of classes that can be linked to this Reactive in the editor
func _get_linkable_class_hint_string():
	return Utility.array_to_hint_string(ProjectSettings.get_global_class_list().map(func(x): return x.class))

## Override to filter the list of properties that can be linked to this Reactive in the editor
func _get_linkable_property_hint_string() -> String:
	if not linked_class:
		return ""
	var instance = Utility.instance_class_from_string_name(linked_class)
	var props = instance.get_property_list().map(func(x): return x.name)
	return Utility.array_to_hint_string(props)

## Override if any double underscore properties are added that don't revert to empty strings
func _property_get_revert(property: StringName) -> Variant:
	if property.begins_with("__"):
		return ""
	return false

func _property_can_revert(property: StringName) -> bool:
	if property.begins_with("__"):
		return get(property.right(-2)) != _property_get_revert(property)
	return false

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		clear_test_value()
