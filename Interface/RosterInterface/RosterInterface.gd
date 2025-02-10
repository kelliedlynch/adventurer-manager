@tool
extends UnitListMenu
class_name RosterInterface

#@onready var unit_list: UnitListMenu = $UnitListMenu

func _ready() -> void:
	title_label.text = "Roster"
	if not Engine.is_editor_hint():
		for unit in Player.roster:
			add_unit(unit)
	else:
		for i in 6:
			add_unit(Adventurer.new())
	super._ready()

static func instantiate(units: Array[Adventurer] = []) -> RosterInterface:
	var menu = load("res://Interface/RosterInterface/RosterInterface.tscn").instantiate()
	for unit in units:
		menu.add_unit(unit)
	return menu
