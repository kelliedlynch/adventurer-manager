extends Control
class_name Menu

@export var is_submenu: bool = false:
	set(value):
		is_submenu = value
		if not is_inside_tree():
			await ready
		_on_is_submenu_changed(value)

signal menu_item_clicked

var _refresh_queued: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
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
	
func _on_is_submenu_changed(val: bool):
	pass

func _process(delta: float) -> void:
	if _refresh_queued:
		_refresh_menu()
		_refresh_queued = false
