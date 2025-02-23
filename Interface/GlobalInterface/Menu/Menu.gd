@tool
extends Reactive
## Displays a list of menu items built from an Array or ObservableArray of objects
## linked_class on a menu refers to the type of the array items
class_name Menu

@export_placeholder("Menu Title") var menu_title: String = "":
	set(value):
		if value != menu_title:
			menu_title = value
			if not is_inside_tree():
				await ready
			title_label.text = menu_title
			title_container.visible = value != ""
			
@export var empty_item_option: bool = false
		
@onready var menu_items_container: Container = find_child("MenuItems")
@onready var title_container: PanelContainer = find_child("TitleContainer")
@onready var title_label: Label = find_child("TitleLabel")

@export var select_multiple: bool = false
var currently_selected: Array[MenuItemBase] = []

signal menu_item_selected

## Override. Build a menu item from the given object.
func build_menu_item(obj: Variant) -> MenuItemBase:
	return null

func add_menu_item(item: MenuItemBase):
	#menu_items.append(item)
	if not is_inside_tree():
		await ready
	menu_items_container.add_child(item)
	item.selected_changed.connect(_on_item_selected_changed.bind(item))
	#_refresh_queued = true
	
func remove_menu_item(item: MenuItemBase):
	menu_items_container.remove_child(item)
	currently_selected.erase(item)
	item.selected_changed.disconnect(_on_item_selected_changed)
	item.queue_free()
	#_refresh_queued = true
	
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

func link_object(obj: Variant, node: Node = self, recursive = true):
	# if obj is an Array or ObservableArray, and obj contains items of type linked_class
	# TODO: I can't wrap my head around if node==self is needed here or not
	if node == self and obj:
		if (obj is ObservableArray and (not linked_class or obj.array_type.get_global_name() == linked_class)):
			build_menu_items(obj)
		elif (obj is Array and (obj.is_typed() and obj.get_typed_class_name() == linked_class))\
						or (!obj.is_empty() and Utility.is_derived_from(obj[0].get_script().get_global_name(), linked_class)):
			build_menu_items(obj)
			linked_object = obj
	super(obj, node, recursive)
		
func build_menu_items(from_list = linked_object):
	if not is_inside_tree():
		await ready
	clear_menu_items()
	for item in from_list:
		add_menu_item(build_menu_item(item))
	if empty_item_option:
		add_menu_item(build_menu_item(null))
	
## Override this if a change in the array should do something other than rebuild the visible list
func _on_linked_observable_object_changed(obj: ObservableArray):
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
