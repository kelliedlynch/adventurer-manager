@tool
extends MenuItemBase
class_name UnitListMenuItem

@onready var portrait_texture_rect: TextureRect = find_child("PortraitTexture")
@onready var equip_slots: HBoxContainer = find_child("EquipSlots")
@onready var weapon_slot: EquipmentSlot = find_child("WeaponSlot")
@onready var armor_slot: EquipmentSlot = find_child("ArmorSlot")
@onready var action_buttons: VBoxContainer = find_child("ActionButtons")
@onready var traits: ReactiveMultiField = find_child("TraitsList")
@onready var main_layout_rows: VBoxContainer = find_child("MainLayoutRows")
@onready var stats_block_body: HBoxContainer = find_child("StatsBlockBody")


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
	resized.connect(_on_size_changed)
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
	
func _on_size_changed():
	#TODO: Would really like to do this without walking up parents
	var width = get_rect().size.x

	if traits.get_parent() == stats_block_body:
		var p_width = get_parent().get_rect().size.x
		var pp_width = get_parent().get_parent().get_rect().size.x
		if (width > p_width or width > pp_width):
			print("traits don't fit, reparenting below")
			traits.reparent(main_layout_rows)
			traits.set("/list_layout", ReactiveMultiField.ContentLayout.HORIZONTAL)
	elif traits.get_parent() == main_layout_rows:
		var p_width = stats_block_body.get_rect().size.x
		var pp_width = stats_block_body.get_parent().get_rect().size.x
		if (width < p_width and width < pp_width):
			print("traits could fit, reparenting inside")
			var children = stats_block_body.get_children()
			var index = children.find(equip_slots)
			var end_children = children.slice(index)
			end_children.map(remove_child)
			traits.reparent(stats_block_body)
			traits.set("/list_layout", ReactiveMultiField.ContentLayout.VERTICAL)
			end_children.map(add_child)
	pass
	
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
	
#func _on_unit_equipment_changed(equip_type: String):
	#if equip_type == "weapon":
		#weapon_slot.item = unit.weapon
	#elif equip_type == "armor":
		#armor_slot.item = unit.armor
	
func _on_armor_clicked():
	pass
		
func add_action_button(text: String, action: Callable) -> Button:
	var button = Button.new()
	button.text = text
	button.pressed.connect(action)
	action_buttons.add_child(button)
	return button

static func instantiate(adv: Adventurer) -> UnitListMenuItem:
	var item = load("res://Interface/GlobalInterface/UnitListMenuItem.tscn").instantiate()
	item.unit = adv
	return item
