@tool
extends UnitMenuItem
class_name UnitListMenuItem


@onready var traits_parent_wide: MarginContainer = find_child("TraitsListWideLayout")
@onready var traits_parent_narrow: MarginContainer = find_child("TraitsListNarrowLayout")
@onready var stat_hp_container: Container = find_child("StatHp")
@onready var stat_mp_container: Container = find_child("StatMp")
#@onready var action_buttons: Container = find_child("ActionButtons")

var registered_buttons: Array[Dictionary] = []

@export var layout_variation: LayoutVariation = LayoutVariation.WIDE:
	set(value):
		if value != layout_variation:
			layout_variation = value
			_set_layout_variation(value)

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Adventurer.generate_random_newbie())
		for child in action_buttons.get_children():
			child.queue_free()
		for i in 3:
			add_action_button("Button " + str(i + 1), func(): pass)
	stat_hp_container.tooltip_text = Stats.stat_hp.abbreviation + ": " + Stats.stat_hp.description
	super()
	
func link_object(obj: Variant, node: Node = self, _recursive = false):
	super(obj, node, obj is Adventurer)
	if obj and obj is Adventurer and linked_object == obj:
		if not is_inside_tree():
			await ready
		weapon_slot.filter = func(x): return x is Weapon and x.status & Equipment.ITEM_NOT_EQUIPPED
		armor_slot.filter = func(x): return x is Armor and x.status & Equipment.ITEM_NOT_EQUIPPED
		for button in registered_buttons:
			var butt = add_action_button(button.text, button.action)
			if not button.active_if.call():
				butt.disabled = true
		if not Engine.is_editor_hint() and not Game.player.roster.has(obj):
			if weapon_slot:
				weapon_slot.select_disabled = true
			if armor_slot:
				armor_slot.select_disabled = true
		elif not Engine.is_editor_hint():
			weapon_slot.selected_changed.connect(_on_slot_clicked.bind(weapon_slot))
			armor_slot.selected_changed.connect(_on_slot_clicked.bind(armor_slot))
	
func unlink_object(obj: Variant, node: Node = self, recursive = false):
	# TODO: Anything else to unlink?
	if linked_object == obj: 
		if weapon_slot.selected_changed.is_connected(_on_slot_clicked):
			weapon_slot.selected_changed.disconnect(_on_slot_clicked)
		if armor_slot.selected_changed.is_connected(_on_slot_clicked):
			armor_slot.selected_changed.disconnect(_on_slot_clicked)
	super(obj, node, recursive)
	
func _set_layout_variation(variation: int):
	if !is_inside_tree():
		await ready
	if variation == LayoutVariation.WIDE:
		if traits.get_parent() != traits_parent_wide:
			traits.reparent(traits_parent_wide)
			traits.list_layout = ContentLayout.VERTICAL
	if variation == LayoutVariation.NARROW_TRAITS_BELOW:
		if traits.get_parent() != traits_parent_narrow:
			traits.reparent(traits_parent_narrow)
			traits.list_layout = ContentLayout.HORIZONTAL
	
func _on_slot_clicked(_val, slot: EquipmentSlot):
	var valid_items = ObservableArray.new(Game.player.inventory.filter(slot.filter), Equipment)
	var inventory_submenu = EquipmentMenuInterface.instantiate(valid_items)
	_configure_equipment_select_menu(slot, inventory_submenu)
	#inventory_submenu.is_root_interface = true
	InterfaceManager.display_interface(inventory_submenu)
	
func _configure_equipment_select_menu(slot: EquipmentSlot, interface: EquipmentMenuInterface):
	if not interface.is_inside_tree():
		await interface.ready
	interface.equipment_menu.menu_item_selected.connect(_on_equipment_selected.bind(slot))
	interface.equipment_menu.menu_item_selected.connect(InterfaceManager.close_interface.bind(interface).unbind(2))
	interface.equipment_menu.empty_item_option = true
	
func _on_equipment_selected(menu_item: EquipmentMenuItem, _val, slot: EquipmentSlot):
	if menu_item.linked_object == null and slot.linked_object:
		linked_object.unequip(slot.linked_object)
		slot.unlink_object(slot.linked_object)
	elif menu_item.linked_object is Weapon:
		linked_object.equip(menu_item.linked_object)
		weapon_slot.link_object(menu_item.linked_object)
	elif menu_item.linked_object is Armor:
		linked_object.equip(menu_item.linked_object)
		armor_slot.link_object(menu_item.linked_object)
	
func add_action_button(text: String, action: Callable) -> Button:
	#if not is_inside_tree(): await ready
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
	var item = preload("res://Interface/GlobalInterface/UnitList/UnitListMenuItem.tscn").instantiate()
	item.link_object(adv)
	return item
