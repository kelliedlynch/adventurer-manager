@tool
extends Reactive
class_name TavernInterface

@onready var for_hire_menu: UnitListMenu = find_child("ForHireMenu")
@onready var name_label: ReactiveTextField = find_child("TavernName")

func _ready() -> void:
	for_hire_menu.register_action_button("Hire", _on_hire_button_pressed, _can_hire_unit)
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Tavern.new())
	

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
	linked_object.hire_adventurer(unit)
	
func link_object(obj: Variant, node: Node = self, recursive = false):
	super(obj, node, recursive)
	if linked_object == obj and linked_object is Tavern:
		if not is_inside_tree():
			await ready
		for_hire_menu.link_object(obj.adventurers_for_hire)
		name_label.link_object(obj)

static func instantiate(tav: Tavern) -> TavernInterface:
	var interface = load("res://Interface/TownInterface/BuildingInterface/TavernInterface.tscn").instantiate()
	interface.link_object(tav)
	return interface
