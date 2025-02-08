@tool
extends HBoxContainer
class_name LabeledField

var _label_label: Label
var _text_label: Label
var _linked_model: Object

@export_placeholder("Label") var label: String = "":
	set(value):
		label = value
		if not is_inside_tree():
			await ready
		if value == "":
			_label_label.visible = false
		else:
			_label_label.visible = true
			_label_label.text = value + ":"

var text: String = "":
	set(value):
		text = value
		if not is_inside_tree():
			await ready
		if text == "":
			_text_label.visible = false
		else:
			_text_label.visible = true
			_text_label.text = value
		
func _ready() -> void:
	#theme_type_variation = "LabeledField"
	_label_label = Label.new()
	_label_label.text = label
	if label == "":
		_label_label.visible = false
	#_label_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#_label_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	add_child(_label_label)
	_text_label = Label.new()
	_text_label.text = text
	if text == "":
		_text_label.visible = false
	#_text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(_text_label)
	#size_flags_horizontal = Control.SIZE_EXPAND_FILL
	theme_changed.connect(_on_theme_changed)
	#await ready
	_on_theme_changed()
	
func _on_theme_changed():
	var variation = theme_type_variation
	var font_size = get_theme_font_size("font_size", variation)
	_label_label.add_theme_font_size_override("font_size", font_size)
	_text_label.add_theme_font_size_override("font_size", font_size)
	pass
	
var _internal_vars: Dictionary = {}
func _set(property, value):
	if property == "/linked_class" or property == "/linked_property":
		if value:
			_internal_vars[property] = value
			notify_property_list_changed()
		if property == "/linked_property":
			text = str(_linked_model.get(value)) if _linked_model else value
		return true
	return false
	
func _get(property):
	if property == "/linked_class" or property == "/linked_property":
		return _internal_vars.get(property)

func _get_property_list() -> Array:
	var props = []
	var custom_classes = ProjectSettings.get_global_class_list()
	props.append({
		name = "/linked_class",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = custom_classes.reduce(func (accum, val): return accum + "," + val.class, "").left(-1)
	})
	var hint_str = ""
	if get("/linked_class"):
		var instance = load(ProjectSettings.get_global_class_list()[custom_classes.find_custom(func (x): return x.class == get("/linked_class"))].path).new()
		hint_str = instance.get_property_list().reduce(func (accum, val): return accum + val.name + ",", "").left(-1)
	props.append({
		name = "/linked_property",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = hint_str
	})
	return props

func watch_object(obj: Object):
	_linked_model = obj
	var prop = get("/linked_property")
	if prop:
		text = str(obj.get(prop))
		obj.property_changed.connect(_on_property_changed)

func _on_property_changed(prop_name: String):
	if prop_name == get("/linked_property"):
		var val = _linked_model.get(get("/linked_property"))
		if val and str(val) != text:
			text = str(val)
			pass
	
