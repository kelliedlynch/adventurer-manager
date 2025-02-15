@tool
extends MenuItemBase
class_name UnitListMenuItem

@onready var portrait_texture_rect: TextureRect = find_child("PortraitTexture")
@onready var weapon_slot: EquipmentSlot = find_child("WeaponSlot")
@onready var armor_slot: EquipmentSlot = find_child("ArmorSlot")
@onready var action_buttons: VBoxContainer = find_child("ActionButtons")
@onready var traits: HBoxContainer = find_child("Traits")

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
			portrait_texture_rect.texture = unit.portrait
			if unit.weapon:
				weapon_slot.item = unit.weapon
			#unit.equipment_changed.connect(_on_unit_equipment_changed)
			for unit_trait in unit.traits:
				var l = Label.new()
				l.text = Trait.trait_name[unit_trait]
				traits.add_child(l)
			watch_reactive_fields(unit, self)

func _ready() -> void:
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
	super._ready()
	
func _on_slot_clicked(_val, slot: EquipmentSlot):
	inventory_submenu = InventoryInterface.instantiate(Player.inventory.filter(slot.filter))
	inventory_submenu.menu_item_selected.connect(_on_equipment_selected)
	inventory_submenu.is_root_interface = true
	InterfaceManager.main_control_node.add_child(inventory_submenu)
	
func _on_equipment_selected(menu_item: InventoryMenuItem, _val):
	if menu_item.item is Weapon:
		unit.weapon = menu_item.item
	elif menu_item.item is Armor:
		unit.armor = menu_item.item
	unit.property_changed.emit("mod_stat_atk")
	unit.property_changed.emit("mod_stat_def")
	inventory_submenu.queue_free()
	
func _on_unit_equipment_changed(equip_type: String):
	if equip_type == "weapon":
		weapon_slot.item = unit.weapon
	elif equip_type == "armor":
		armor_slot.item = unit.armor
	
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
