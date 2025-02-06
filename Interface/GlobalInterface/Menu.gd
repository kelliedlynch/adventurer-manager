extends Control
class_name Menu

@onready var window_size: Vector2 = get_window().size

func _ready() -> void:
	get_window().size_changed.connect(_on_window_size_changed)
	
func _on_window_size_changed() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()
