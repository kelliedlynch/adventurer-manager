@tool
extends Interface
class_name RosterInterface

@onready var unit_list: UnitListMenu = $UnitListMenu

func _ready() -> void:
	if not Engine.is_editor_hint():
		for unit in Player.roster:
			unit_list.add_unit(unit)
	else:
		for i in 6:
			unit_list.add_unit(Adventurer.generate_random_newbie())

static func instantiate(units: Array[Adventurer] = []) -> RosterInterface:
	var menu = load("res://Interface/RosterInterface/RosterInterface.tscn").instantiate()
	return menu
