@tool
extends Reactive
class_name HospitalInterface

@onready var injured_units: UnitListMenu = find_child("InjuredUnits")
@onready var building_name: ReactiveTextField = find_child("BuildingNameLabel")
@onready var heal_button: Button = find_child("HealButton")
@onready var selected_unit: UnitListMenuItem = find_child("SelectedUnit")

var heal_cost: int = 0:
	set(value):
		heal_cost = value
		heal_button.text = str(value)
		heal_button.disabled = value == 0

func _ready() -> void:
	linked_object.refresh_injured_units()
	heal_button.pressed.connect(_on_heal_button_pressed)
	heal_button.disabled = heal_cost == 0 or heal_cost > Game.player.money
	injured_units.menu_item_selected.connect(_add_to_hospital)
	selected_unit.selected_changed.connect(_remove_from_hospital)
	selected_unit.visible = false
	
func _add_to_hospital(item: UnitListMenuItem, val: bool):
	if !val: return
	if selected_unit.linked_object:
		_remove_from_hospital(true, selected_unit)
	selected_unit.link_object(item.linked_object)
	item.linked_object.status |= Adventurer.STATUS_IN_BUILDING
	selected_unit.input_state = UnitListMenuItem.NORMAL
	selected_unit.visible = true
	linked_object.injured_units.erase(selected_unit.linked_object)
	#injured_units.remove_unit(item.linked_object)
	heal_cost = item.linked_object.stat_hp - item.linked_object.current_hp

func _remove_from_hospital(selected: bool, item: UnitListMenuItem = selected_unit):
	if selected:
		item.linked_object.status &= ~Adventurer.STATUS_IN_BUILDING
		if selected_unit.linked_object.current_hp < selected_unit.linked_object.stat_hp:
			linked_object.injured_units.append(selected_unit.linked_object)
		selected_unit.unlink_object(item.linked_object)
		selected_unit.visible = false
		heal_cost = 0
	
func _on_heal_button_pressed():
	selected_unit.linked_object.heal_damage()
	Game.player.money -= heal_cost
	selected_unit.linked_object.status &= ~Adventurer.STATUS_IN_BUILDING
	heal_cost = 0
	selected_unit.unlink_object(selected_unit.linked_object, selected_unit, true)
	selected_unit.visible = false
	
func link_object(obj: Variant, node: Node = self, recursive = false):
	super(obj, node, recursive)
	if obj is Hospital:
		if not is_inside_tree():
			await ready
		building_name.link_object(obj)
		injured_units.link_object(obj.injured_units)

static func instantiate(hospital: Hospital) -> HospitalInterface:
	var interface = load("res://Interface/TownInterface/BuildingInterface/HospitalInterface.tscn").instantiate()
	interface.link_object(hospital)
	return interface
