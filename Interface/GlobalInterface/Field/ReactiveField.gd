@tool
extends Reactive
class_name ReactiveField

var linked_property: StringName = ""

#func update_from_object():
	#super()
	#if not linked_property: return

func _property_can_revert(property: StringName) -> bool:
	if property == "__linked_property":
		return linked_property != _property_get_revert("__linked_property")
	return super(property)
	
func _property_get_revert(property: StringName) -> Variant:
	if property == "__linked_property":
		return ""
	return super(property)

func _get_property_list() -> Array:
	# Everything here is solely for updating the view in the editor. Do not use double underscore
	# properties in scripts.
	var props = []
	if not Engine.is_editor_hint(): return props
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
