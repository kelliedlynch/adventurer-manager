@tool
extends PanelContainer
class_name DialogBox

@export var message: String = "Confirmation message"

@onready var message_label: Label = $VBoxContainer/Message
@onready var action_buttons: HBoxContainer = $VBoxContainer/ActionButtons

func _ready() -> void:
	message_label.text = message
	#for child in action_buttons.get_children():
		#child.queue_free()
	#add_cancel_button()
	
func add_action_button(text: String, action: Callable, close_after: bool = true):
	var button = Button.new()
	button.text = text
	button.pressed.connect(action)
	if close_after and action != close_dialog:
		button.pressed.connect(close_dialog)
	if not is_inside_tree():
		await ready
	action_buttons.add_child(button)
	#button.owner = self

func add_cancel_button(text: String = "Cancel"):
	add_action_button(text, close_dialog)

func close_dialog():
	queue_free()

static func instantiate() -> DialogBox:
	return load("res://Interface/GlobalInterface/DialogBox.tscn").instantiate()
