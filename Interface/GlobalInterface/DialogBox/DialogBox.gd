extends Reactive
class_name DialogBox

@export var message: String = "Confirmation message"

@onready var message_label: Label = find_child("Message")
@onready var action_buttons: HBoxContainer = find_child("ActionButtons")

func _ready() -> void:
	message_label.text = message
	
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

func _gui_input(event: InputEvent) -> void:
	if InterfaceManager.interface_stack[-1] == self:
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		close_dialog()

static func instantiate() -> DialogBox:
	return load("res://Interface/GlobalInterface/DialogBox/DialogBox.tscn").instantiate()
