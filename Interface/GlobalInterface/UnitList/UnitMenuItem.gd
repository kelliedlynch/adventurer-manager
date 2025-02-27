@tool
extends MenuItemBase
class_name UnitMenuItem
# Base class for menu items that display an adventurer

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
@onready var name_value: ReactiveTextField = find_child("UnitName")
@onready var level_value: ReactiveTextField = find_child("LevelValue")
@onready var class_value: ReactiveTextField = find_child("ClassValue")
@onready var stat_hp_value: ReactiveProgressField = find_child("StatHpValue")
@onready var stat_values_block: GridContainer = find_child("StatValuesBlock")

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		set_reactive_defaults()
		link_object(Adventurer.generate_random_newbie())
	super()
	
func link_object(obj: Variant, node: Node = self, recursive = false):
	super(obj, node, recursive)
	if obj and obj is Adventurer:
		if not is_inside_tree():
			await ready
		weapon_slot.link_object(obj.weapon)
		armor_slot.link_object(obj.armor)
	
	
func set_reactive_defaults():
	linked_class = "Adventurer"
	name_value.linked_class = "Adventurer"
	name_value.linked_property = "unit_name"
	level_value.linked_class = "Adventurer"
	level_value.linked_property = "level"
	class_value.linked_class = "Adventurer"
	class_value.linked_property = "adventurer_class"
	stat_hp_value.linked_class = "Adventurer"
	stat_hp_value.linked_property = "current_hp"
	stat_hp_value.max_value_property = "stat_hp"
	traits.linked_class = "Adventurer"
	traits.linked_property = "traits"
	
func _on_unit_set(unit: Adventurer):
	if weapon_slot:
		weapon_slot.item = unit.weapon
	if armor_slot:
		armor_slot.item = unit.armor
