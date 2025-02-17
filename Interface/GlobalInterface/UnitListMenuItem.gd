@tool
extends MenuItemBase
class_name UnitListMenuItem

@onready var portrait_texture_rect: TextureRect = find_child("PortraitTexture")
@onready var equip_slots: HBoxContainer = find_child("EquipSlots")
@onready var weapon_slot: EquipmentSlot = find_child("WeaponSlot")
@onready var armor_slot: EquipmentSlot = find_child("ArmorSlot")
@onready var action_buttons: VBoxContainer = find_child("ActionButtons")
@onready var traits: ReactiveMultiField = find_child("TraitsList")
@onready var traits_parent_wide: MarginContainer = find_child("TraitsListWideLayout")
@onready var traits_parent_narrow: MarginContainer = find_child("TraitsListNarrowLayout")

@export var layout_variation: LayoutVariation = LayoutVariation.WIDE:
	set(value):
		if value != layout_variation:
			layout_variation = value
			_set_layout_variation(value)

var inventory_submenu: InventoryInterface

@export var portrait_size: Vector2:
	set(value):
		portrait_size = value
		if not is_inside_tree():
			await ready
		portrait_texture_rect.custom_minimum_size = value
		
var unit: Adventurer = null:
	set(value):
		unit = value
		if unit:
			if not is_inside_tree():
				await ready
			if unit.weapon:
				weapon_slot.item = unit.weapon
			if unit.armor:
				armor_slot.item = unit.armor
			portrait_texture_rect.texture = unit.portrait
			watch_reactive_fields(unit, self)

func _ready() -> void:
	_set_layout_variation(layout_variation)
	if get_tree().current_scene == self or Engine.is_editor_hint():
		unit = Adventurer.generate_random_newbie()
		for child in action_buttons.get_children():
			child.queue_free()
		for i in 3:
			add_action_button("Button " + str(i + 1), func(): pass)
	if unit:
		weapon_slot.selected_changed.connect(_on_slot_clicked.bind(weapon_slot))
		armor_slot.selected_changed.connect(_on_slot_clicked.bind(armor_slot))
		weapon_slot.filter = func(x): return x is Weapon and x.status & Equipment.ITEM_NOT_EQUIPPED
		armor_slot.filter = func(x): return x is Armor and x.status & Equipment.ITEM_NOT_EQUIPPED
	super()
	
func _set_layout_variation(variation: int):
	if !is_inside_tree():
		await ready
	if variation == LayoutVariation.WIDE:
		if traits.get_parent() != traits_parent_wide:
			traits.reparent(traits_parent_wide)
			traits.set("/list_layout", ReactiveMultiField.ContentLayout.VERTICAL)
	if variation == LayoutVariation.NARROW_TRAITS_BELOW:
		if traits.get_parent() != traits_parent_narrow:
			traits.reparent(traits_parent_narrow)
			traits.set("/list_layout", ReactiveMultiField.ContentLayout.HORIZONTAL)

	
func _on_slot_clicked(_val, slot: EquipmentSlot):
	inventory_submenu = InventoryInterface.instantiate(Game.player.inventory.filter(slot.filter))
	inventory_submenu.menu_item_selected.connect(_on_equipment_selected)
	inventory_submenu.is_root_interface = true
	InterfaceManager.main_control_node.add_child(inventory_submenu)
	
func _on_equipment_selected(menu_item: InventoryMenuItem, _val):
	if menu_item.item is Weapon:
		unit.weapon = menu_item.item
		weapon_slot.item = unit.weapon
	elif menu_item.item is Armor:
		unit.armor = menu_item.item
		armor_slot.item = unit.armor
	inventory_submenu.queue_free()
	
func add_action_button(text: String, action: Callable) -> Button:
	var button = Button.new()
	button.text = text
	button.pressed.connect(action)
	action_buttons.add_child(button)
	return button
	
enum LayoutVariation {
	WIDE,
	NARROW_TRAITS_BELOW
}

static func instantiate(adv: Adventurer) -> UnitListMenuItem:
	var item = preload("res://Interface/GlobalInterface/UnitListMenuItem.tscn").instantiate()
	item.unit = adv
	return item
