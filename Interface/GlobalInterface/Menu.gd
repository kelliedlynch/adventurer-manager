extends Control
class_name Menu

@export var is_submenu: bool = false:
	set(value):
		is_submenu = value
		if not is_inside_tree():
			await ready
		_on_is_submenu_changed(value)
		
@onready var list_items_container: VBoxContainer
var menu_items: Array[MenuItemBase] = []

func add_menu_item(item: MenuItemBase):
	menu_items.append(item)
	item.selected.connect(_on_item_selected.bind(item))
	
func remove_menu_item(item: MenuItemBase):
	menu_items.remove_at(menu_items.find(item))
	item.selected.disconnect(_on_item_selected)
	
func clear_menu_items():
	for item in menu_items:
		remove_menu_item(item)
	
func _on_item_selected(item: MenuItemBase):
	menu_item_selected.emit(item)

signal menu_item_selected

var _refresh_queued: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		GameplayEngine.game_tick_advanced.connect(set.bind("_refresh_queued", true))
	list_items_container = find_child("ListItems")

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
