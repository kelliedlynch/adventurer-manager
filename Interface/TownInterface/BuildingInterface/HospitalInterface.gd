extends Menu
class_name HospitalInterface

@onready var injured_units: UnitListMenu = $VBoxContainer/HBoxContainer/InjuredUnits
@onready var select_unit_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/HBoxContainer/SelectUnitLabel
@onready var heal_button: Button = $VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/HBoxContainer/HealButton
@onready var selected_unit: UnitListMenuItem = $VBoxContainer/HBoxContainer/VBoxContainer/SelectedUnit

var heal_cost: int = 0:
	set(value):
		heal_cost = value
		heal_button.text = str(value)
		heal_button.disabled = value == 0
		

var model: Hospital:
	set(value):
		model = value
		if not is_inside_tree():
			await ready
		_get_injured_units()
			
func _ready() -> void:
	heal_button.pressed.connect(_on_heal_button_pressed)
	heal_button.disabled = heal_cost == 0
	injured_units.menu_item_selected.connect(_add_to_hospital)
	selected_unit.selected.connect(_remove_from_hospital)
	selected_unit.visible = false
	super._ready()
	
func _add_to_hospital(unit: Adventurer):
	if selected_unit.unit:
		_remove_from_hospital(selected_unit.unit)
	selected_unit.unit = unit
	selected_unit.visible = true
	injured_units.remove_unit(unit)
	heal_cost = unit.stat_hp - unit.current_hp

func _remove_from_hospital(unit: Adventurer):
	selected_unit.unit = null
	selected_unit.visible = false
	injured_units.add_unit(unit)
	heal_cost = 0
	pass
	
func _on_heal_button_pressed():
	selected_unit.unit.current_hp = selected_unit.unit.stat_hp
	Player.money -= heal_cost
	heal_cost = 0
	selected_unit.unit = null
	selected_unit.visible = false
	
	
func _get_injured_units():
	#injured_units.clear_units()
	var units = Player.roster.filter(func(x): return x.current_hp < x.stat_hp)
	for unit in units:
		injured_units.add_unit(unit)

static func instantiate(hospital: Hospital) -> HospitalInterface:
	var menu = load("res://Interface/TownInterface/BuildingInterface/HospitalInterface.tscn").instantiate()
	menu.model = hospital
	return menu
