@tool
extends ReactiveField
class_name ReactiveProgressField

@onready var max_value_label: Label = find_child("MaxValue")
@onready var divider_label: Label = find_child("ValueDivider")
@onready var current_value_label: Label = find_child("CurrentValue")

@export var show_max: bool = false:
	set(value):
		show_max = value
		if not is_inside_tree():
			await ready
		max_value_label.visible = value
		divider_label.visible = value

@export var max_value_divider: String = "/":
	set(value):
		max_value_divider = value
		if not is_inside_tree():
			await ready
		divider_label.text = value

func _init() -> void:
	#super()
	_internal_vars_list.append("/max_value_property")

		
func _ready() -> void:
	theme_changed.connect(_on_theme_changed)
	_on_theme_changed()
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		show_max = true
		current_value_label.text = "50"
		max_value_label.text = "100"
		max_value_divider = "/"
	#else:
		#max_value_label.text = max_value_divider
	#super()
#func _on_tree_exiting():
	#if get_tree().edited_scene_root == self:
		#label = ""
		#label_divider = ":"
		
	
func _on_theme_changed():
	var variation = theme_type_variation
	var font_size = get_theme_font_size("font_size", variation)
	divider_label.add_theme_font_size_override("font_size", font_size)
	current_value_label.add_theme_font_size_override("font_size", font_size)
	max_value_label.add_theme_font_size_override("font_size", font_size)

func _get_property_list() -> Array:
	if get("/linked_class"):
		var hint_str = Utility.array_to_hint_string(get_watchable_properties())
		return [{
			name = "/max_value_property",
			type = TYPE_STRING_NAME,
			hint = PROPERTY_HINT_ENUM,
			hint_string = hint_str
		}]
	return[]
	#return props

#func watch_object(obj: Object):
	#linked_model = obj
	#var prop = get("/linked_property")
	##if prop:
		##property_value = str(obj.get(prop))
	#var max_prop = get("/max_val_property")
	#if max_prop:
		#max_value = str(obj.get(max_prop))
	#if prop or max_prop:
		#if not obj.property_changed.is_connected(_on_property_changed):
			#obj.property_changed.connect(_on_property_changed)

func _on_property_changed(prop_name: String):
	super(prop_name)
	if prop_name == get("/linked_property"):
		current_value_label.text = str(linked_model.get(get("/linked_property")))
	if prop_name == get("/max_value_property"):
		max_value_label.text = str(linked_model.get(get("/max_value_property")))
		max_value_label.visible = show_max and max_value_label.text != ""
		divider_label.visible = max_value_label.visible
