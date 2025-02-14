@tool
extends Container
class_name ReactiveField

@onready var _icon: TextureRect = find_child("Icon")
@onready var _field_label: Label = find_child("FieldLabel")
@onready var _curr_val_label: Label = find_child("CurrentValue")
@onready var _max_val_label: Label = find_child("MaxValue")
var _linked_model: Object

@export_placeholder("Label") var label: String = "":
	set(value):
		label = value
		if not is_inside_tree():
			await ready
		_field_label.text = value + label_divider
		_field_label.visible = label != ""
			
@export var label_divider: String = ":":
	set(value):
		label_divider = value
		if not is_inside_tree():
			await ready
		_field_label.text = label + value
		
@export var icon: Texture2D:
	set(value):
		icon = value
		if not is_inside_tree():
			await ready
		_icon.texture = value
		_icon.visible = value != null
			
#@export var show_max: bool = false:
	#set(value):
		#show_max = value
		#if not is_inside_tree():
			#await ready
		#_max_val_label.visible = value
		#_max_val_label.text = max_val_divider + max_val
#
#var max_val: String = "":
	#set(value):
		#max_val = value
		#if not is_inside_tree():
			#await ready
		#if max_val == "":
			#_max_val_label.visible = false
		#else:
			#_max_val_label.visible = true
			#_max_val_label.text = max_val_divider + value
#
#@export var max_val_divider: String = "/":
	#set(value):
		#max_val_divider = value
		#if not is_inside_tree():
			#await ready
		#_max_val_label.text = max_val_divider + max_val

#var curr_val: String = "":
	#set(value):
		#curr_val = value
		#if not is_inside_tree():
			#await ready
		#if curr_val == "":
			#_curr_val_label.visible = false
		#else:
			#_curr_val_label.visible = true
			#_curr_val_label.text = value
		
func _ready() -> void:
	if get_tree().edited_scene_root != self:
		label = label
		label_divider = label_divider
		#show_max = show_max
		#curr_val = curr_val
		#max_val = max_val
		#max_val_divider = max_val_divider
		icon = icon
	theme_changed.connect(_on_theme_changed)
	_on_theme_changed()
	
func _on_theme_changed():
	var variation = theme_type_variation
	var font_size = get_theme_font_size("font_size", variation)
	#_field_label.add_theme_font_size_override("font_size", font_size)
	#_curr_val_label.add_theme_font_size_override("font_size", font_size)
	#_max_val_label.add_theme_font_size_override("font_size", font_size)
	pass
	
var _internal_vars: Dictionary = {}
var _internal_vars_list: PackedStringArray = ["/linked_class", "/linked_property", "/max_val_property"]
func _set(property, value):
	if _internal_vars_list.has(property):
		if value:
			_internal_vars[property] = value
			notify_property_list_changed()
			#if property == "/linked_property":
				#curr_val = str(_linked_model.get(value)) if _linked_model else value
			#if property == "/max_val_property":
				#max_val = str(_linked_model.get(value)) if _linked_model else value
		return true
	return false
	
func _get(property):
	if _internal_vars_list.has(property):
		return _internal_vars.get(property)

func _get_property_list() -> Array:
	var props = []
	var custom_classes = ProjectSettings.get_global_class_list()
	props.append({
		name = "/linked_class",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = custom_classes.reduce(_class_filter, "").left(-1)
	})
	var hint_str = ""
	if get("/linked_class"):
		var instance = load(custom_classes[custom_classes.find_custom(func (x): return x.class == get("/linked_class"))].path).new()
		hint_str = instance.get_property_list().reduce(_property_list_filter, "").left(-1)
	props.append_array([{
		name = "/linked_property",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = hint_str
	},
	{
		name = "/max_val_property",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = hint_str
	}])
	return props
	
func _class_filter(accum, val):
	var file = FileAccess.open(val.path, FileAccess.READ)
	var content: String = file.get_as_text()
	if content.find("signal property_changed") == -1 and content.find("property_changed.emit(") == -1:
		return accum
	return accum + "," + val.class

var _excluded_properties: PackedStringArray = ["RefCounted", "Resource", "resource_local_to_scene", "script", "resource_path", "resource_name", "resource_scene_unique_id"]
func _property_list_filter(accum, val):
	if _excluded_properties.has(val.name): return accum
	return accum + val.name + ","

func watch_object(obj: Object):
	_linked_model = obj
	var prop = get("/linked_property")
	#if prop:
		#curr_val = str(obj.get(prop))
	var max_prop = get("/max_val_property")
	#if max_prop:
		#max_val = str(obj.get(max_prop))
	if prop or max_prop:
		if not obj.property_changed.is_connected(_on_property_changed):
			obj.property_changed.connect(_on_property_changed)

func _on_property_changed(prop_name: String):
	if prop_name == get("/linked_property"):
		var val = _linked_model.get(get("/linked_property"))
		#if val and str(val) != curr_val:
			#curr_val = str(val)
	if prop_name == get("/max_val_property"):
		var new_max_val = _linked_model.get(get("/max_val_property"))
		#if new_max_val and str(new_max_val) != max_val:
			#max_val = str(new_max_val)
