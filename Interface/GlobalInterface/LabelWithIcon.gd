@tool
extends HBoxContainer
class_name LabelWithIcon

@onready var field_label: Label = find_child("FieldLabel")
@onready var icon_rect: TextureRect = find_child("Icon")

@export_placeholder("Label") var label: String = "":
	set(value):
		label = value
		if not is_inside_tree():
			await ready
		field_label.text = value + label_divider
		field_label.visible = label != ""
			
@export var label_divider: String = ":":
	set(value):
		label_divider = value
		if not is_inside_tree():
			await ready
		field_label.text = label + value
		
@export var icon: Texture2D:
	set(value):
		icon = value
		if not is_inside_tree():
			await ready
		icon_rect.texture = value
		icon_rect.visible = icon != null
		
func _ready() -> void:
	var unit = Adventurer.generate_random_newbie()
	unit._foo = ""
