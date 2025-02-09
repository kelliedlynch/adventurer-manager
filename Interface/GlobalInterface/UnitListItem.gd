@tool
extends PanelContainer
class_name UnitListItem

@onready var _portrait_frame: PanelContainer = $HBoxContainer/PortraitFrame
@onready var _portrait_texture_rect: TextureRect = $HBoxContainer/PortraitFrame/TextureRect
@onready var action_buttons: VBoxContainer = $HBoxContainer/ActionButtons

#var _labeled_fields: Array[LabeledField] = []

@export var portrait_style: StyleBox:
	set(value):
		portrait_style = value
		if not is_inside_tree():
			await ready
		#_portrait_frame.add_theme_stylebox_override("panel", value)
		
@export var portrait_size: Vector2:
	set(value):
		portrait_size = value
		if not is_inside_tree():
			await ready
		_portrait_texture_rect.custom_minimum_size = value
		
var unit: Adventurer = null:
	set(value):
		unit = value

signal item_clicked

func _ready() -> void:
	if get_tree().current_scene == self or (Engine.is_editor_hint() and unit == null):
		unit = Adventurer.new()
		for child in $HBoxContainer/ActionButtons.get_children():
			child.queue_free()
		for i in 3:
			add_action_button("Button " + str(i + 1), func(): pass)
	if unit:
		_portrait_texture_rect.texture = unit.portrait
	gui_input.connect(_on_gui_input)
		
func _on_gui_input(event: InputEvent):
	if event.is_action("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		item_clicked.emit()

func add_action_button(text: String, action: Callable) -> Button:
	var button = Button.new()
	button.text = text
	button.pressed.connect(action)
	action_buttons.add_child(button)
	return button

static func instantiate():
	return load("res://Interface/GlobalInterface/UnitListItem.tscn").instantiate()

#func _update_list_item():
	#for prop in unit.get_property_list():
		#
		#pass
