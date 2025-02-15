@tool
extends ReactiveField
class_name ReactiveProgressField

@export var show_max: bool = false:
	set(value):
		show_max = value
		if not is_inside_tree():
			await ready

var max_value: String = "":
	set(value):
		max_value = value
		if not is_inside_tree():
			await ready

@export var max_value_divider: String = "/":
	set(value):
		max_value_divider = value
		if not is_inside_tree():
			await ready

		
func _ready() -> void:
	_internal_vars_list.append("/max_value_property")
	#if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		#show_max = true
		#property_value = "50"
		#max_value = "100"
		#max_value_divider = "/"

#func _on_tree_exiting():
	#if get_tree().edited_scene_root == self:
		#label = ""
		#label_divider = ":"
		
	
#func _on_theme_changed():
	#var variation = theme_type_variation
	#var font_size = get_theme_font_size("font_size", variation)
	#field_label.add_theme_font_size_override("font_size", font_size)
	#curr_val_label.add_theme_font_size_override("font_size", font_size)
	#max_value_label.add_theme_font_size_override("font_size", font_size)
	#pass


func _get_property_list() -> Array:
	if get("/linked_class"):
		var hint_str = get_watchable_properties_hint_string()
		return [{
			name = "/max_value_property",
			type = TYPE_STRING_NAME,
			hint = PROPERTY_HINT_ENUM,
			hint_string = hint_str
		}]
	return[]
	#return props

func watch_object(obj: Object):
	linked_model = obj
	var prop = get("/linked_property")
	#if prop:
		#property_value = str(obj.get(prop))
	var max_prop = get("/max_val_property")
	if max_prop:
		max_value = str(obj.get(max_prop))
	if prop or max_prop:
		if not obj.property_changed.is_connected(_on_property_changed):
			obj.property_changed.connect(_on_property_changed)

func _on_property_changed(prop_name: String):
	if prop_name == get("/linked_property"):
		var val = linked_model.get(get("/linked_property"))
		#if val and str(val) != property_value:
			#property_value = str(val)
	if prop_name == get("/max_val_property"):
		var new_max_val = linked_model.get(get("/max_val_property"))
		if new_max_val and str(new_max_val) != max_value:
			max_value = str(new_max_val)
