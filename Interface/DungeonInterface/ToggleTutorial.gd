extends Control

signal tut_toggled

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint() and Input.is_action_just_pressed("ui_toggle_tutorial"):
		visible = !visible
		tut_toggled.emit()
		get_window().set_input_as_handled()
