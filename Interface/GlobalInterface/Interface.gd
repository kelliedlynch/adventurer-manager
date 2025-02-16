extends Container
class_name Interface

@export var is_root_interface: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		Game.game_tick_advanced.connect(_refresh_interface)

func _refresh_interface():
	pass

func watch_reactive_fields(watched, current_node) -> void:
	for child in current_node.get_children():
		if child.get("/linked_class"):
			if child.get("/linked_class") == "Town":
				print("Town being watched, class is ", watched.get_script().get_global_name())
			if child is ReactiveField and Utility.is_derived_from(watched.get_script().get_global_name(), child.get("/linked_class")):
				child.linked_model = watched
				if child.linked_model is Town:
					print("linking town", child.linked_model.town_name)
		watch_reactive_fields(watched, child)

func _input(event: InputEvent) -> void:
	if is_root_interface and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()
