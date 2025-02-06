@tool
extends Menu
class_name Roster

@onready var units: Array[Adventurer] = Player.roster
@onready var unit_list: UnitList = $UnitList

func _ready() -> void:
	unit_list._units = Player.roster

static func instantiate() -> Roster:
	return load("res://Interface/RosterInterface/Roster.tscn").instantiate()
