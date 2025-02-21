@tool
extends UnitMenuItem
class_name UnitListMenuItem


@onready var traits_parent_wide: MarginContainer = find_child("TraitsListWideLayout")
@onready var traits_parent_narrow: MarginContainer = find_child("TraitsListNarrowLayout")

@export var layout_variation: LayoutVariation = LayoutVariation.WIDE:
	set(value):
		if value != layout_variation:
			layout_variation = value
			_set_layout_variation(value)

var inventory_submenu: EquipmentMenu

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Adventurer.generate_random_newbie())
		for child in action_buttons.get_children():
			child.queue_free()
		for i in 3:
			add_action_button("Button " + str(i + 1), func(): pass)
	weapon_slot.selected_changed.connect(_on_slot_clicked.bind(weapon_slot))
	armor_slot.selected_changed.connect(_on_slot_clicked.bind(armor_slot))
	super()
	
func link_object(obj: Variant, node: Node = self):
	if obj and Utility.is_derived_from(obj.get_script().get_global_name(), linked_class):
		if not is_inside_tree():
			await ready
		weapon_slot.filter = func(x): return x is Weapon and x.status & Equipment.ITEM_NOT_EQUIPPED
		armor_slot.filter = func(x): return x is Armor and x.status & Equipment.ITEM_NOT_EQUIPPED
	super(obj, node)
	
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
	var a = Game.player.inventory.filter(slot.filter)
	inventory_submenu = EquipmentMenu.instantiate(a)
	inventory_submenu.closeable = true
	inventory_submenu.menu_item_selected.connect(_on_equipment_selected)
	#inventory_submenu.is_root_interface = true
	InterfaceManager.main_control_node.add_child(inventory_submenu)
	
func _on_equipment_selected(menu_item: EquipmentMenuItem, _val):
	if menu_item.linked_object is Weapon:
		linked_object.weapon = menu_item.linked_object
		weapon_slot.link_object(linked_object.weapon)
	elif menu_item.linked_object is Armor:
		linked_object.armor = menu_item.linked_object
		armor_slot.link_object(linked_object.armor)
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
	var item = preload("res://Interface/GlobalInterface/UnitList/UnitListMenuItem.tscn").instantiate()
	item.link_object(adv)
	return item
