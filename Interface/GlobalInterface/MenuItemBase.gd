@tool
extends PanelContainer
class_name MenuItemBase

var input_state: int = NORMAL:
	set(value):
		input_state = value
		input_state_changed.emit(value)
signal input_state_changed

signal selected


func _ready() -> void:

	input_state_changed.connect(_on_input_state_changed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)

func _watch_labeled_fields(watched, current_node) -> void:
	for child in current_node.get_children():
		if child is LabeledField:
			child.watch_object(watched)
		_watch_labeled_fields(watched, child)
		
func _on_gui_input(event: InputEvent):
	if event.is_action("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		if not input_state & PRESSED:
			input_state += PRESSED
			selected.emit()
		else:
			input_state -= PRESSED

func _on_input_state_changed(state: int):
	remove_theme_stylebox_override("panel")
	if state & PRESSED:
		add_theme_stylebox_override("panel", get_theme_stylebox("pressed", theme_type_variation))
	elif state & HOVERED:
		add_theme_stylebox_override("panel", get_theme_stylebox("hover", theme_type_variation))
	elif state & FOCUSED:
		add_theme_stylebox_override("panel", get_theme_stylebox("focus", theme_type_variation))
	else:
		add_theme_stylebox_override("panel", get_theme_stylebox("panel", theme_type_variation))

func _on_mouse_entered():
	if not input_state & HOVERED:
		input_state += HOVERED
		
func _on_mouse_exited():
	if input_state & HOVERED:
		input_state -= HOVERED
		
func _on_focus_entered():
	if not input_state & FOCUSED:
		input_state += FOCUSED

func _on_focus_exited():
	if input_state & FOCUSED:
		input_state -= FOCUSED

enum {
	NORMAL = 0,
	PRESSED = 1,
	FOCUSED = 2,
	HOVERED = 4
}
