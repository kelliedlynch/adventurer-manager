@tool
extends MenuItemBase
class_name TownBuildingMenuItem

@onready var name_label: ReactiveTextField = find_child("BuildingName")
@onready var description_label: ReactiveTextField = find_child("BuildingDescription")
@onready var enter_button: Button = find_child("EnterBuilding")

func _ready() -> void:
	if get_tree().edited_scene_root == self or get_tree().current_scene == self:
		link_object(Building.new(), self, true)
	if not Engine.is_editor_hint():
		enter_button.pressed.connect(_open_building_interface)

func _open_building_interface():
	var interface = linked_object.interface.instantiate(linked_object)
	InterfaceManager.display_interface(interface)

static func instantiate(bldg: Building) -> TownBuildingMenuItem:
	var menu = load("res://Interface/TownInterface/TownBuildingMenuItem.tscn").instantiate()
	menu.link_object(bldg, menu, true)
	return menu
