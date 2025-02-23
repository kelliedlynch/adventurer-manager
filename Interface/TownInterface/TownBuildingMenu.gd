@tool
extends Menu

func _ready() -> void:
	if get_tree().edited_scene_root == self or get_tree().current_scene == self:
		link_object(Town.new().buildings)

func build_menu_item(building: Variant) -> MenuItemBase:
	var new_item = TownBuildingMenuItem.instantiate(building)
	new_item.select_disabled = true
	return new_item
