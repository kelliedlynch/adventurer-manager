extends Interface
class_name RosterInterface

@onready var unit_list: UnitListMenu = $UnitListMenu

func _ready() -> void:
	if not Engine.is_editor_hint():
		for unit in Game.player.roster:
			unit_list.add_unit(unit)
	else:
		for i in 6:
			unit_list.add_unit(Adventurer.generate_random_newbie())

static func instantiate() -> RosterInterface:
	var menu = load("res://Interface/PlayerMenuInterface/RosterInterface.tscn").instantiate()
	return menu
