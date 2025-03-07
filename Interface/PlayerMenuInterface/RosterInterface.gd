@tool
extends Reactive
class_name RosterInterface

@onready var unit_list: UnitListMenu = $UnitListMenu

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		var adventurers = ObservableArray.new()
		adventurers.array_type = Adventurer
		for i in 10:
			adventurers.append(AdventurerFactory.generate_random_newbie())
		unit_list.link_object(adventurers)

func link_object(obj: Variant, _node: Node = self, _recursive: bool = true):
	if obj and obj is PlayerData:
		if not is_inside_tree():
			await ready
		unit_list.link_object(obj.roster)
	#super(obj, node, recursive)

static func instantiate() -> RosterInterface:
	var menu = load("res://Interface/PlayerMenuInterface/RosterInterface.tscn").instantiate()
	menu.link_object(Game.player)
	return menu
