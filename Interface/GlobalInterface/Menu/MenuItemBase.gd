@tool
extends Interface
class_name MenuItemBase

var input_state: int = NORMAL:
	set(value):
		input_state = value
		input_state_changed.emit(value)
signal input_state_changed

var selected: bool = false:
	set(value):
		if !select_disabled:
			selected = value
			input_state &= PRESSED if value else ~PRESSED
			selected_changed.emit(value)
signal selected_changed

var select_disabled: bool = false

func _ready() -> void:
	input_state_changed.connect(_on_input_state_changed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
		
func _on_gui_input(event: InputEvent):
	if event.is_action("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		selected = !selected

func _on_input_state_changed(state: int):
	var normal = "panel"
	remove_theme_stylebox_override(normal)
	if state & PRESSED:
		add_theme_stylebox_override(normal, get_theme_stylebox("pressed", theme_type_variation))
	elif state & HOVERED:
		add_theme_stylebox_override(normal, get_theme_stylebox("hover", theme_type_variation))
	elif state & FOCUSED:
		add_theme_stylebox_override(normal, get_theme_stylebox("focus", theme_type_variation))
	else:
		add_theme_stylebox_override(normal, get_theme_stylebox(normal, theme_type_variation))

func _on_mouse_entered():
	input_state |= HOVERED
		
func _on_mouse_exited():
	input_state &= ~HOVERED
		
func _on_focus_entered():
	input_state |= FOCUSED

func _on_focus_exited():
	input_state &= ~FOCUSED

enum {
	NORMAL = 0,
	PRESSED = 1,
	FOCUSED = 2,
	HOVERED = 4
}
