extends Building
class_name Tavern

var adventurers_for_hire: Array[Adventurer] = []

signal adventurers_for_hire_changed

func _init() -> void:
	GameplayEngine.game_tick_advanced.connect(_on_game_tick_advanced)

func _on_game_tick_advanced():
	var available_adventurers = adventurers_for_hire.size()
	if available_adventurers < 10:
		for i in 10 - available_adventurers:
			_add_new_adventurer_for_hire()

func _add_new_adventurer_for_hire():
	adventurers_for_hire.append(Adventurer.new())
	adventurers_for_hire_changed.emit()
