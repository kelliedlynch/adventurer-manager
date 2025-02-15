@tool
extends Control
class_name ReactiveField

var linked_model: Object:
	set(value):
		linked_model = value
		if not value.property_changed.is_connected(_on_property_changed):
			value.property_changed.connect(_on_property_changed)
		_on_property_changed("/linked_model")

var _internal_vars: Dictionary = {}
var _internal_vars_list: PackedStringArray = ["/linked_class", "/linked_property"]
func _set(property, value):
	if _internal_vars_list.has(property):
		if value:
			_internal_vars[property] = value
			notify_property_list_changed()
		return true
	return false
	
func _get(property):
	if _internal_vars_list.has(property):
		return _internal_vars.get(property)

func _get_property_list() -> Array:
	var props = []
	var watchable = ProjectSettings.get_global_class_list().filter(func(x): return Utility.is_derived_from(x.class, "Watchable"))
	props.append({
		name = "/linked_class",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = watchable.reduce(func(accum, val): return accum + val.class + ",", "").left(-1)
	})

	if get("/linked_class"):
		var hint_str = get_watchable_properties_hint_string(watchable)
		props.append({
			name = "/linked_property",
			type = TYPE_STRING_NAME,
			hint = PROPERTY_HINT_ENUM,
			hint_string = hint_str
		})
	return props
	
func get_watchable_properties_hint_string(watchable: Array[Dictionary] = []):
	if not get("/linked_class"):
		return ""
	if watchable.is_empty():
		watchable = ProjectSettings.get_global_class_list()
	var index = watchable.find_custom(func (x): return x.class == get("/linked_class"))
	var watchable_class = watchable[index]
	var instance = load(watchable_class.path).new()
	var hint_str = instance.watchable_props.reduce(_reduce_prop_list, "").left(-1)
	return hint_str
	
func _reduce_prop_list(accum, val):
	return accum + val + ","
	
func _class_filter(accum, val):
	var file = FileAccess.open(val.path, FileAccess.READ)
	var content: String = file.get_as_text()
	if content.find("signal property_changed") == -1 and content.find("property_changed.emit(") == -1:
		return accum
	return accum + "," + val.class

func _on_property_changed(prop_name: String):
	if prop_name == "/linked_model":
		for prop in linked_model.watchable_props:
			_on_property_changed(prop)
