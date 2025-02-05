@tool
extends Menu
class_name TavernInterface

@onready var unit_list: UnitList = $HBoxContainer/UnitList

var model: Tavern:
	set(value):
		model = value
		if not is_inside_tree():
			await ready
		unit_list._units = value.adventurers_for_hire
		value.adventurers_for_hire_changed.connect(unit_list._refresh_list)

func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		model = Tavern.new()
	unit_list.register_action_button("Hire", _on_hire_button_pressed)

func _on_hire_button_pressed(unit: Adventurer):
	var dialog = DialogBox.instantiate()
	dialog.message = "Hire this adventurer?"
	dialog.add_action_button("Yes", _confirm_hire.bind(unit))
	dialog.add_cancel_button("No")
	add_child(dialog)
	
func _confirm_hire(unit: Adventurer):
	model.hire_adventurer(unit)
