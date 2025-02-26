@tool
extends Reactive
## Displays a list of menu items built from an ObservableArray of objects
class_name Menu

@export_placeholder("Menu Title") var menu_title: String = "":
	set(value):
		if value != menu_title:
			menu_title = value
			if not is_inside_tree():
				await ready
			title_label.text = menu_title
			title_container.visible = value != ""
			
@export var empty_item_option: bool = false:
	set(value):
		empty_item_option = value
		if is_inside_tree():
			build_menu_items()
		
@onready var menu_items_container: Container = find_child("MenuItems")
@onready var title_container: PanelContainer = find_child("TitleContainer")
@onready var title_label: Label = find_child("TitleLabel")

@export var select_multiple: bool = false
var currently_selected: Array[MenuItemBase] = []

signal menu_item_selected

## Override. Build a menu item from the given object.
func build_menu_item(_obj: Variant) -> MenuItemBase:
	return null

func add_menu_item(item: MenuItemBase):
	if not is_inside_tree():
		await ready
	menu_items_container.add_child(item)
	item.selected_changed.connect(_on_item_selected_changed.bind(item))
	
func remove_menu_item(item: MenuItemBase):
	menu_items_container.remove_child(item)
	currently_selected.erase(item)
	item.selected_changed.disconnect(_on_item_selected_changed)
	item.queue_free()
	
func clear_menu_items():
	for item in get_menu_items():
		remove_menu_item(item)
		
func get_menu_items():
	return menu_items_container.get_children().filter(func(x): return x is MenuItemBase)
	
func get_menu_item_for_object(obj: Variant) -> MenuItemBase:
	for item in get_menu_items():
		if item.linked_object == obj:
			return item
	return null

func link_object(obj: Variant, node: Node = self, recursive = false):
	if node == self and obj:
		if obj is Array and ((obj.is_typed() and obj.get_typed_class_name() == linked_class)\
						or (!obj.is_empty() and Utility.is_derived_from(obj[0].get_script().get_global_name(), linked_class))):
			linked_object = obj
	super(obj, node, recursive)
	if linked_object:
		build_menu_items()
		
func build_menu_items(from_list = linked_object):
	if not is_inside_tree():
		await ready
	clear_menu_items()
	for item in from_list:
		add_menu_item(build_menu_item(item))
	if empty_item_option:
		add_menu_item(build_menu_item(null))
	
## Override this if a change in the array should do something other than rebuild the visible list
func _on_linked_observable_object_changed(_obj: ObservableArray):
	build_menu_items()

func _on_item_selected_changed(val: bool, item: MenuItemBase):
	if !val:
		currently_selected.erase(item)
	if val and !select_multiple and !currently_selected.is_empty():
		for curr in currently_selected:
			curr.selected = false
			currently_selected.clear()
	currently_selected.append(item)
	menu_item_selected.emit(item, val)

func _property_get_revert(property: StringName) -> Variant:
	if property == "__menu_item_type":
		return 0
	if property == "__layout_type":
		return 0
	return super(property)
