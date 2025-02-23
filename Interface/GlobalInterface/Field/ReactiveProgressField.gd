@tool
extends ReactiveField
class_name ReactiveProgressField

var max_value_property: StringName = ""
var show_max_value: bool = true
var max_value_divider: String = "/"

@onready var max_value_label: Label = find_child("MaxValue")
@onready var divider_label: Label = find_child("ValueDivider")
@onready var current_value_label: Label = find_child("CurrentValue")

func _ready() -> void:
	theme_changed.connect(_on_theme_changed)
	_on_theme_changed()
	
func _on_theme_changed():
	var variation = theme_type_variation
	var font_size = get_theme_font_size("font_size", variation)
	divider_label.add_theme_font_size_override("font_size", font_size)
	current_value_label.add_theme_font_size_override("font_size", font_size)
	max_value_label.add_theme_font_size_override("font_size", font_size)
	
func get_test_value(property: StringName):
	if property == "__test_current_value":
		return current_value_label.text
	elif property == "__test_max_value":
		return max_value_label.text

func set_test_value(property: StringName, value: Variant):
	if not is_inside_tree():
		await ready
	if property == "__test_current_value":
		current_value_label.text = value
	elif property == "__test_max_value":
		max_value_label.text = value

func clear_test_value():
	current_value_label.text = ""
	max_value_label.text = ""

#func _property_get_revert(property: StringName) -> Variant:
	#if property == "__test_current_value":
		#return ""
	#if property == "__test_max_value":
		#return ""
	#return super(property)

func _get_property_list() -> Array:
	var props = []
	if linked_class:
		props.append({
			name = "__max_value_property",
			type = TYPE_STRING_NAME,
			hint = PROPERTY_HINT_ENUM,
			hint_string = _get_linkable_property_hint_string()
		})
	props.append_array([{
		name = "__show_max_value",
		type = TYPE_BOOL
	},
	{
		name = "__max_value_divider",
		type = TYPE_STRING
	},
	{
		name = "__test_current_value",
		type = TYPE_STRING
	},
	{
		name = "__test_max_value",
		type = TYPE_STRING
	},
	])

	return props

func update_from_linked_object():
	divider_label.visible = show_max_value
	max_value_label.visible = show_max_value
	if linked_object:
		if max_value_property:
			max_value_label.text = str(linked_object.get(max_value_property))
		if linked_property:
			current_value_label.text = str(linked_object.get(linked_property))
