@tool
extends Menu
## A menu that displays a list of equipment with optional filters and remove button
# Note: filters not implemented yet
class_name EquipmentMenu

@export var no_item_option: bool = false:
	set(value):
		if value:
			add_menu_item(EquipmentMenuItem.instantiate(null))
		else:
			var index = menu_items.find_custom(func(x): return x.linked_object == null)
			if index != -1:
				remove_menu_item(menu_items[index])

func link_object(obj: Variant, node: Node = self):
	if obj and obj is Array[Equipment]:
		clear_menu_items()
		for item in obj:
			add_menu_item(EquipmentMenuItem.instantiate(item))
		if no_item_option:
			add_menu_item(EquipmentMenuItem.instantiate(null))
		return
	super(obj, node)

static func instantiate(items: Array[Equipment] = []) -> EquipmentMenu:
	var menu = preload("res://Interface/PlayerMenuInterface/EquipmentMenu.tscn").instantiate()
	menu.link_object(items)
	return menu
