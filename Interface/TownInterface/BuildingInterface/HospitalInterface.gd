extends Reactive
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

#var model: Hospital:
	#set(value):
		#model = value
		#if not is_inside_tree():
			#await ready
		#_refresh_interface()
			
func _ready() -> void:
	heal_button.pressed.connect(_on_heal_button_pressed)
	heal_button.disabled = heal_cost == 0 or heal_cost > Game.player.money
	injured_units.menu_item_selected.connect(_add_to_hospital)
	selected_unit.selected_changed.connect(_remove_from_hospital)
	selected_unit.visible = false
	#super._ready()
	
func _add_to_hospital(item: UnitListMenuItem, val: bool):
	if !val: return
	if selected_unit.unit:
		_remove_from_hospital(selected_unit)
	selected_unit.unit = item.unit
	item.unit.status |= Adventurer.STATUS_IN_BUILDING
	selected_unit.input_state = UnitListMenuItem.NORMAL
	selected_unit.visible = true
	injured_units.remove_unit(item.unit)
	heal_cost = item.unit.stat_hp - item.unit.current_hp

func _remove_from_hospital(item: UnitListMenuItem = selected_unit):
	item.unit.status &= ~Adventurer.STATUS_IN_BUILDING
	injured_units.add_unit(item.unit)
	selected_unit.unit = null
	selected_unit.visible = false
	heal_cost = 0
	pass
	
func _on_heal_button_pressed():
	selected_unit.unit.current_hp = selected_unit.unit.stat_hp
	Game.player.money -= heal_cost
	heal_cost = 0
	selected_unit.unit = null
	selected_unit.visible = false
	
func _refresh_interface():
	var injured = _get_injured_units()
	var existing = injured_units.units
	if injured == existing:
		return
	for inj in injured:
		if !existing.has(inj):
			injured_units.add_unit(inj)
	for exist in existing:
		if !injured.has(exist):
			injured_units.remove_unit(exist)
	
func _get_injured_units() -> Array[Adventurer]:
	#injured_units.clear_units()
	return Game.player.roster.filter(func(x): return x.current_hp < x.stat_hp)
	

static func instantiate(hospital: Hospital) -> HospitalInterface:
	var menu = load("res://Interface/TownInterface/BuildingInterface/HospitalInterface.tscn").instantiate()
	menu.model = hospital
	return menu
