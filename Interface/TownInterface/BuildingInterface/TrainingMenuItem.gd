@tool
extends MenuItemBase
class_name TrainingMenuItem

@onready var trait_name_label: Label = find_child("TraitNameLabel")

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Trait.TraitList.pick_random())
		create_action_button("Button", func(x): return)
	super()

func create_action_button(text: String, action: Callable, active_if: Callable = func(x): return true):
	super(text, action, active_if)
	if not is_inside_tree(): await ready
	var button = action_buttons.get_children()[-1]
	button.icon = load("res://Graphics/Icons/coin_01.png")
	button.custom_minimum_size.x = 150
	button.expand_icon = true
	#button.text = str(linked_object.training_cost)

func link_object(obj: Variant, node: Node = self, recursive = false):
	super(obj, node, recursive)
	if obj is Trait:
		if not is_inside_tree(): await ready
		trait_name_label.link_object(obj)

static func instantiate(with_trait: Trait) -> TrainingMenuItem:
	var menu = preload("res://Interface/TownInterface/BuildingInterface/TrainingMenuItem.tscn").instantiate()
	menu.link_object(with_trait)
	return menu
