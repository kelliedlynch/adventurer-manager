extends Control
class_name Menu

@export_placeholder("Menu Title") var menu_title: String:
	set(value):
		if value != menu_title:
			menu_title = value
			if not is_inside_tree():
				await ready
			title_label.text = menu_title
			title_container.visible = value != ""
			
@export var is_submenu: bool = false
		
@onready var menu_items_container: VBoxContainer = find_child("MenuItems")
@onready var title_container: PanelContainer = find_child("TitleContainer")
@onready var title_label: Label = find_child("TitleLabel")

var _menu_items: Array[MenuItemBase] = []

func add_menu_item(item: MenuItemBase):
	_menu_items.append(item)
	if not is_inside_tree():
		await ready
	menu_items_container.add_child(item)
	item.selected.connect(_on_item_selected.bind(item))
	#_refresh_queued = true
	
func remove_menu_item(item: MenuItemBase):
	_menu_items.remove_at(_menu_items.find(item))
	#menu_items_container.remove_child(item)
	item.selected.disconnect(_on_item_selected)
	item.queue_free()
	#_refresh_queued = true
	
func clear_menu_items():
	for item in _menu_items:
		remove_menu_item(item)
	
func _on_item_selected(item: MenuItemBase):
	menu_item_selected.emit(item)

signal menu_item_selected

var _refresh_queued: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		GameplayEngine.game_tick_advanced.connect(set.bind("_refresh_queued", true))

func _input(event: InputEvent) -> void:
	if not is_submenu and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()

func watch_labeled_fields(watched, current_node) -> void:
	for child in current_node.get_children():
		if child is LabeledField:
			child.watch_object(watched)
		watch_labeled_fields(watched, child)

func _refresh_menu():
	pass

func _process(delta: float) -> void:
	if _refresh_queued:
		_refresh_menu()
		_refresh_queued = false
