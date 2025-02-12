@tool
extends MenuItemBase
class_name UnitListMenuItem

@onready var _portrait_frame: PanelContainer = find_child("PortraitFrame")
@onready var _portrait_texture_rect: TextureRect = find_child("PortraitTexture")
@onready var action_buttons: VBoxContainer = find_child("ActionButtons")

@export var portrait_size: Vector2:
	set(value):
		portrait_size = value
		if not is_inside_tree():
			await ready
		_portrait_texture_rect.custom_minimum_size = value
		
var unit: Adventurer = null:
	set(value):
		unit = value
		if unit:
			if not is_inside_tree():
				await ready
			_portrait_texture_rect.texture = unit.portrait
			watch_labeled_fields(unit, self)
			#print("after watch ", unit.adventurer_class, value.adventurer_class)

func _ready() -> void:
	if get_tree().current_scene == self or (Engine.is_editor_hint() and unit == null):
		unit = Adventurer.generate_random_newbie()
		for child in action_buttons.get_children():
			child.queue_free()
		for i in 3:
			add_action_button("Button " + str(i + 1), func(): pass)
	if unit:
		_portrait_texture_rect.texture = unit.portrait
		#print("before_watch ", unit.adventurer_class, find_child("Class").curr_val, find_child("Class").find_child("CurrentValue").text)
		#watch_labeled_fields(unit, self)
		#print("after_watch ", unit.adventurer_class, find_child("Class").curr_val, find_child("Class").find_child("CurrentValue").text)
	super._ready()
		
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
