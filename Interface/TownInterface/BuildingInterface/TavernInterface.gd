@tool
extends Menu
class_name TavernInterface

@onready var unit_list: UnitList = $VBoxContainer/HBoxContainer/UnitList
@onready var name_label: LabeledField = $VBoxContainer/TavernName

var model: Tavern:
	set(value):
		model = value
		if not is_inside_tree():
			await ready
		unit_list._units = value.adventurers_for_hire
		value.adventurers_for_hire_changed.connect(unit_list._refresh_list)
		Player.property_changed.connect(func(x): unit_list._refresh_list())
		name_label.watch_object(model)

func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		model = Tavern.new()
	unit_list.register_action_button("Hire", _on_hire_button_pressed, _can_hire_unit)

func _can_hire_unit(unit: Adventurer) -> bool:
	return Player.money >= unit.hire_cost

func _on_hire_button_pressed(unit: Adventurer):
	var dialog = DialogBox.instantiate()
	dialog.message = "Hire this adventurer for %d money?" % unit.hire_cost
	dialog.add_action_button("Yes", _confirm_hire.bind(unit))
	dialog.add_cancel_button("No")
	add_child(dialog)
	
func _confirm_hire(unit: Adventurer):
	model.hire_adventurer(unit)
	
func _on_player_money_changed():
	pass

static func instantiate() -> TavernInterface:
	return load("res://Interface/TownInterface/BuildingInterface/TavernInterface.tscn").instantiate()
