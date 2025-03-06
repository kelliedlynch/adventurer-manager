@tool
extends Menu
class_name TrainingMenu

func _ready() -> void:
	menu_item_class = TrainingMenuItem
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		register_action_button("Button", func(x): return)
		link_object(Trait.TraitList)
		
func build_menu_item(obj: Variant) -> MenuItemBase:
	var item = super(obj)
	for button in item.buttons:
		button.text = linked_object.training_cost
	return item

static func instantiate(traits: Array[Trait]) -> UnitListMenu:
	var menu = preload("res://Interface/TownInterface/BuildingInterface/TrainingMenu.tscn").instantiate()
	menu.link_object(traits)
	return menu
