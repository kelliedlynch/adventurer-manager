extends Menu
#class_name Roster

@onready var units: Array[Adventurer] = Player.roster
@onready var unit_list: UnitList = $UnitList

func _ready() -> void:
	name = "RosterMenu"
	for unit in Player.roster:
		unit_list.add_unit(unit)
