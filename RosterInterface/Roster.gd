extends Control
#class_name Roster

@onready var units: Array[Adventurer] = Player.roster
@onready var unit_list: ScrollContainer = $UnitList

func _ready() -> void:
	name = "RosterMenu"
	unit_list.units = units
