@tool
extends PanelContainer
class_name UnitListItem

@onready var _portrait_frame: PanelContainer = $HBoxContainer/PortraitFrame
@onready var _portrait_texture_rect: TextureRect = $HBoxContainer/PortraitFrame/TextureRect
@onready var action_buttons: VBoxContainer = $HBoxContainer/ActionButtons

var _labeled_fields: Array[LabeledField] = []

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
		#if not is_inside_tree():
			#await ready
		#_update_list_item()

func _ready() -> void:
	if get_tree().current_scene == self or (Engine.is_editor_hint() and unit == null):
		unit = Adventurer.new()
		for child in $HBoxContainer/ActionButtons.get_children():
			child.queue_free()
		for i in 3:
			add_action_button("Button " + str(i + 1), func(): pass)
	if unit:
		_watch_labeled_fields(unit, self)
		#await get_tree().process_frame

		_portrait_texture_rect.texture = unit.portrait
		
func _watch_labeled_fields(watched, current_node) -> void:
	for child in current_node.get_children():
		if child is LabeledField:
			child.watch_object(watched)
		_watch_labeled_fields(watched, child)

#TODO: Action buttons disappear after hiring. Fix that.
func add_action_button(text: String, action: Callable):
	var button = Button.new()
	button.text = text
	button.pressed.connect(action)
	action_buttons.add_child(button)

static func instantiate():
	return load("res://Interface/GlobalInterface/UnitListItem.tscn").instantiate()

#func _update_list_item():
	#for prop in unit.get_property_list():
		#
		#pass
