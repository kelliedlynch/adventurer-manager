@tool
extends MenuItemBase
class_name UnitMenuItem

@export var show_equipment: bool = true:
	set(value):
		show_equipment = value
		if not is_inside_tree():
			await ready
		if equip_slots:
			equip_slots.visible = value
@export var show_traits: bool = true:
	set(value):
		show_traits = value
		if not is_inside_tree():
			await ready
		if traits:
			traits.visible = value
@export var show_stats: bool = true:
	set(value):
		show_stats = value
		if not is_inside_tree():
			await ready
		if stats:
			stats.visible = value

@onready var equip_slots: Container = find_child("EquipSlots")
@onready var weapon_slot: EquipmentSlot = find_child("WeaponSlot")
@onready var armor_slot: EquipmentSlot = find_child("ArmorSlot")
@onready var action_buttons: Container = find_child("ActionButtons")
@onready var portrait: UnitPortrait = find_child("Portrait")
@onready var traits: ReactiveMultiField = find_child("TraitsList")
@onready var stats: Container = find_child("StatValuesBlock")
		
var unit: Adventurer = null:
	set(value):
		unit = value
		if unit:
			if not is_inside_tree():
				await ready
			watch_reactive_fields(unit, self)
			_on_unit_set(value)

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		unit = Adventurer.generate_random_newbie()
	super()
	
func _on_unit_set(unit: Adventurer):
	if weapon_slot:
		weapon_slot.item = unit.weapon
	if armor_slot:
		armor_slot.item = unit.armor
