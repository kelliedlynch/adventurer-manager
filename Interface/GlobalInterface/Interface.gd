@tool
extends Container
class_name Interface

@export var is_root_interface: bool = false

func _ready() -> void:
	GameplayEngine.game_tick_advanced.connect(_refresh_interface)

func _refresh_interface():
	pass

func watch_labeled_fields(watched, current_node) -> void:
	for child in current_node.get_children():
		if child is LabeledField and watched.get_script().get_global_name() == child.get("/linked_class"):
			child.watch_object(watched)
		watch_labeled_fields(watched, child)

func _input(event: InputEvent) -> void:
	if is_root_interface and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()
