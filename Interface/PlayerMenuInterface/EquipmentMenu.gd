@tool
extends Menu
class_name EquipmentMenu

func link_object(obj: Variant, node: Node = self):
	if obj and obj is Array[Equipment]:
		clear_menu_items()
		for item in obj:
			add_menu_item(EquipmentMenuItem.instantiate(item))
		return
	super(obj, node)

static func instantiate(items: Array[Equipment] = []) -> EquipmentMenu:
	var menu = preload("res://Interface/PlayerMenuInterface/EquipmentMenu.tscn").instantiate()
	menu.link_object(items)
	return menu
