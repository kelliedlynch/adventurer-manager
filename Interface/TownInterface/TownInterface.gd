@tool
extends Reactive
class_name TownInterface

@onready var name_field: ReactiveTextField = find_child("TownName")
@onready var building_menu: Menu = find_child("TownBuildingMenu")

func _ready() -> void:
	if get_tree().edited_scene_root == self or get_tree().current_scene == self:
		print("linking town")
		link_object(Town.new())

func link_object(obj: Variant, node: Node = self, recursive = false):
	super(obj, node, obj is Town)
	if node == self and obj is Town:
		if not is_inside_tree():
			await ready
		name_field.link_object(obj)
		building_menu.link_object(obj.buildings)

static func instantiate(for_town: Town) -> TownInterface:
	var menu = load("res://Interface/TownInterface/TownInterface.tscn").instantiate()
	menu.link_object(for_town)
	return menu
