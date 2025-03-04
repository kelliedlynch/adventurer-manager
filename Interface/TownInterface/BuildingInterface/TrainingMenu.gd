@tool
extends Menu
class_name TrainingMenu


		
#func build_menu_item(obj: Variant) -> MenuItemBase:
	#var item = TrainingMenuItem.new()
	#return item

static func instantiate(traits: Array[Trait]) -> UnitListMenu:
	var menu = preload("res://Interface/TownInterface/BuildingInterface/TrainingMenu.tscn").instantiate()
	menu.link_object(traits)
	return menu
