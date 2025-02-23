extends Reactive
class_name TavernInterface

@onready var for_hire_menu: UnitListMenu = find_child("ForHireMenu")
@onready var name_label: ReactiveField = find_child("TavernName")

var model: Tavern:
	set(value):
		model = value
		if not is_inside_tree():
			await ready
		for unit in model.adventurers_for_hire:
			for_hire_menu.add_unit(unit)
		if not Engine.is_editor_hint():
			value.adventurers_for_hire_changed.connect(_refresh_for_hire_list)
			name_label.linked_model = model

func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		model = Tavern.new()
	for_hire_menu.register_action_button("Hire", _on_hire_button_pressed, _can_hire_unit)

func _can_hire_unit(unit: Adventurer) -> bool:
	if Engine.is_editor_hint():
		return true
	return Game.player.money >= unit.hire_cost

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

func _refresh_for_hire_list():
	for unit in for_hire_menu.units:
		if !model.adventurers_for_hire.has(unit):
			for_hire_menu.remove_unit(unit)
	for unit in model.adventurers_for_hire:
		if !for_hire_menu.units.has(unit):
			for_hire_menu.add_unit(unit)

static func instantiate(tav: Tavern) -> TavernInterface:
	var menu = load("res://Interface/TownInterface/BuildingInterface/TavernInterface.tscn").instantiate()
	menu.model = tav
	return menu
