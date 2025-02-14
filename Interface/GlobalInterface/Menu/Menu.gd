extends Interface
class_name Menu

@export_placeholder("Menu Title") var menu_title: String:
	set(value):
		if value != menu_title:
			menu_title = value
			if not is_inside_tree():
				await ready
			title_label.text = menu_title
			title_container.visible = value != ""
		
@onready var menu_items_container: Container = find_child("MenuItems")
@onready var title_container: PanelContainer = find_child("TitleContainer")
@onready var title_label: Label = find_child("TitleLabel")

@export var select_multiple: bool = false
var currently_selected: Array[MenuItemBase] = []

var _menu_items: Array[MenuItemBase] = []

func add_menu_item(item: MenuItemBase):
	_menu_items.append(item)
	if not is_inside_tree():
		await ready
	menu_items_container.add_child(item)
	item.selected_changed.connect(_on_item_selected_changed.bind(item))
	#_refresh_queued = true
	
func remove_menu_item(item: MenuItemBase):
	_menu_items.erase(item)
	currently_selected.erase(item)
	item.selected_changed.disconnect(_on_item_selected_changed)
	item.queue_free()
	#_refresh_queued = true
	
func clear_menu_items():
	for item in _menu_items:
		remove_menu_item(item)
	
func _on_item_selected_changed(val: bool, item: MenuItemBase):
	if !val:
		currently_selected.erase(item)
	if val and !select_multiple and !currently_selected.is_empty():
		for curr in currently_selected:
			curr.selected = false
			currently_selected.clear()
	currently_selected.append(item)
	menu_item_selected.emit(item, val)

signal menu_item_selected

var _refresh_queued: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		GameplayEngine.game_tick_advanced.connect(set.bind("_refresh_queued", true))

func _refresh_menu():
	pass

func _process(_delta: float) -> void:
	if _refresh_queued:
		_refresh_menu()
		_refresh_queued = false
