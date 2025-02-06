extends Building
class_name Tavern

var adventurers_for_hire: Array[Adventurer] = []

signal adventurers_for_hire_changed

func _init() -> void:
	building_name = "Tavern"
	building_description = "Hire adventurers, and nothing else yet."
	interface = TavernInterface
	if not Engine.is_editor_hint():
		GameplayEngine.game_tick_advanced.connect(_on_game_tick_advanced)
	else:
		_on_game_tick_advanced()

func hire_adventurer(unit: Adventurer):
	var index = adventurers_for_hire.find(unit)
	if index != -1:
		if Player.money >= unit.hire_cost:
			Player.money -= unit.hire_cost
			Player.roster.append(unit)
			adventurers_for_hire.remove_at(index)
			adventurers_for_hire_changed.emit()

func _on_game_tick_advanced():
	var available_adventurers = adventurers_for_hire.size()
	if available_adventurers < 10:
		for i in 10 - available_adventurers:
			_add_new_adventurer_for_hire()

func _add_new_adventurer_for_hire():
	adventurers_for_hire.append(Adventurer.new())
	adventurers_for_hire_changed.emit()
