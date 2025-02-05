extends Menu
class_name Roster

@onready var units: Array[Adventurer] = Player.roster
@onready var unit_list: UnitList = $UnitList

func _ready() -> void:
	name = "RosterMenu"
	#if not is_inside_tree():
		#await ready
	unit_list._units = Player.roster
