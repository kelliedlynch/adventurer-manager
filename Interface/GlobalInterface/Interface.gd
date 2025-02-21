@tool
extends Reactive
class_name Interface
# An Interface is a "screen" that contains menus or other elements

#@export var is_root_interface: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		Game.game_tick_advanced.connect(_refresh_interface)

func _refresh_interface():
	pass

#func watch_reactive_fields(watched, current_node) -> void:
	#for child in current_node.get_children():
		#if child is ReactiveField and child.linked_class:
			#if watched == null or Utility.is_derived_from(watched.get_script().get_global_name(), child.linked_class):
					#child.linked_model = watched
		#watch_reactive_fields(watched, child)
		
