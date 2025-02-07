extends Control
class_name Menu

@export var is_submenu = false

signal menu_item_clicked

func _input(event: InputEvent) -> void:
	if not is_submenu and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()

func _watch_labeled_fields(watched, current_node) -> void:
	for child in current_node.get_children():
		if child is LabeledField:
			child.watch_object(watched)
		_watch_labeled_fields(watched, child)
