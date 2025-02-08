@tool
extends Menu
class_name RosterInterface

@onready var units: Array[Adventurer] = Player.roster
@onready var unit_list: UnitList = $UnitList

func _ready() -> void:
	unit_list._units = Player.roster
	super._ready()

static func instantiate(units: Array[Adventurer] = []) -> RosterInterface:
	var menu = load("res://Interface/RosterInterface/RosterInterface.tscn").instantiate()
	menu.units = units
	return menu
