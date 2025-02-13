@tool
extends MenuItemBase
class_name UnitListMenuItem

@onready var portrait_texture_rect: TextureRect = find_child("PortraitTexture")
@onready var weapon_slot: EquipmentSlot = find_child("WeaponSlot")
@onready var armor_slot: EquipmentSlot = find_child("ArmorSlot")
@onready var action_buttons: VBoxContainer = find_child("ActionButtons")

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
				weapon_slot.texture = unit.weapon.texture
			weapon_slot.selected.connect(_on_slot_clicked)
			watch_labeled_fields(unit, self)

func _ready() -> void:
	if get_tree().current_scene == self or (Engine.is_editor_hint() and unit == null):
		unit = Adventurer.generate_random_newbie()
		for child in action_buttons.get_children():
			child.queue_free()
		for i in 3:
			add_action_button("Button " + str(i + 1), func(): pass)
	if unit:
		#portrait_texture_rect.texture = unit.portrait

		if unit.armor:
			armor_slot.texture = unit.armor_texture
		armor_slot.selected.connect(_on_armor_clicked)
	super._ready()
	
func _on_slot_clicked(slot: EquipmentSlot):
	var menu = InventoryInterface.instantiate(Player.inventory.filter(slot.filter))
	get_tree().current_scene.add_child(menu)
	
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
