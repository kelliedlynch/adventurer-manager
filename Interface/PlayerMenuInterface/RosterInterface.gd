@tool
extends Interface
class_name RosterInterface

@onready var unit_list: UnitListMenu = $UnitListMenu

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		unit_list.clear_menu_items()
		for i in 10:
			unit_list.add_unit(Adventurer.generate_random_newbie())

func link_object(obj: Variant, node: Node = self):
	if obj and obj is PlayerData:
		if not is_inside_tree():
			await ready
		#unit_list.clear_menu_items()
		#for item in obj.roster:
			#unit_list.add_unit(item)
		unit_list.link_object(obj.roster)
		return
	super(obj, node)

static func instantiate() -> RosterInterface:
	var menu = load("res://Interface/PlayerMenuInterface/RosterInterface.tscn").instantiate()
	menu.link_object(Game.player)
	return menu
