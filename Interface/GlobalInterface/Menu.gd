extends Control
class_name Menu

@export var is_submenu = false

signal menu_item_clicked

var _refresh_queued: bool = false

func _ready() -> void:
	GameplayEngine.game_tick_advanced.connect(set.bind("_refresh_queued", true))

func _input(event: InputEvent) -> void:
	if not is_submenu and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()

func _watch_labeled_fields(watched, current_node) -> void:
	for child in current_node.get_children():
		if child is LabeledField:
			child.watch_object(watched)
		_watch_labeled_fields(watched, child)

func _refresh_menu():
	pass

func _process(delta: float) -> void:
	if _refresh_queued:
		_refresh_menu()
		_refresh_queued = false
