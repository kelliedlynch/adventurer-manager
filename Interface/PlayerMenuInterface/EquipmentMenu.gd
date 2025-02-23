@tool
extends Menu
## A menu that displays a list of equipment with optional filters and remove button
# Note: filters not implemented yet
class_name EquipmentMenu

func build_menu_item(obj: Variant) -> MenuItemBase:
	return EquipmentMenuItem.instantiate(obj)

static func instantiate(items: ObservableArray) -> EquipmentMenu:
	var menu = preload("res://Interface/PlayerMenuInterface/EquipmentMenu.tscn").instantiate()
	menu.link_object(items)
	return menu
