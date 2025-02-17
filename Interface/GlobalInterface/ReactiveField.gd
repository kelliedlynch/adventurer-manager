@tool
extends Control
class_name ReactiveField

var linked_model: Object:
	set(value):
		linked_model = value

var _internal_vars: Dictionary = {}
var _internal_vars_list: PackedStringArray = ["/linked_class", "/linked_property"]
func _set(property, value):
	if _internal_vars_list.has(property):
		_internal_vars[property] = value
		notify_property_list_changed()
		return true
	return false
	
func _get(property):
	if _internal_vars_list.has(property):
		return _internal_vars.get(property)

func _get_property_list() -> Array:
	var props = []
	var custom_classes = ProjectSettings.get_global_class_list()
	#var watchable = custom_classes.filter(func(x): return Utility.is_derived_from(x.class, "Watchable"))
	props.append({
		name = "/linked_class",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = custom_classes.reduce(func(accum, val): return accum + val.class + ",", "").left(-1)
	})

	if get("/linked_class"):
		props.append({
			name = "/linked_property",
			type = TYPE_STRING_NAME,
			hint = PROPERTY_HINT_ENUM,
			hint_string = get_property_hint_string()
		})
	return props
	
func get_property_hint_string() -> String:
	return Utility.array_to_hint_string(get_watchable_properties())
	
func get_watchable_properties() -> Array:
	if not get("/linked_class"):
		return []
	var instance = Utility.instance_class_from_string_name(get("/linked_class"))
	return instance.get_property_list().map(func(x): return x.name)
