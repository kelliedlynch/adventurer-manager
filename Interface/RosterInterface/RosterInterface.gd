@tool
extends Menu
class_name RosterInterface

@onready var units: Array[Adventurer]
@onready var unit_list: UnitListMenu = $UnitListMenu

func _ready() -> void:
	if not Engine.is_editor_hint():
		units = Player.roster
		unit_list._units = Player.roster
	else:
		for i in 6:
			unit_list.add_unit(Adventurer.new())
		units = unit_list.units
	super._ready()

static func instantiate(units: Array[Adventurer] = []) -> RosterInterface:
	var menu = load("res://Interface/RosterInterface/RosterInterface.tscn").instantiate()
	menu.units = units
	return menu
