@tool
extends Reactive
class_name TrainingGroundInterface

@onready var trainable_units: UnitListMenu = find_child("TrainableUnits")
@onready var building_name: ReactiveTextField = find_child("BuildingNameLabel")
@onready var training_menu: Menu = find_child("TrainingMenu")
@onready var selected_unit_menu: Menu = find_child("SelectedUnit")

var selected_unit: Adventurer:
	get:
		var items = selected_unit_menu.get_menu_items()
		if items.is_empty(): return null
		return items[0].linked_object

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		
		var train = TrainingGround.new()
		for i in 6:
			train.trainable_units.append(AdventurerFactory.generate_random_newbie())
		link_object(train)
		selected_unit_menu.add_menu_item(selected_unit_menu.build_menu_item(AdventurerFactory.generate_random_newbie()))
	training_menu.register_action_button("Train", _on_train_button_pressed, _is_training_possible)
	trainable_units.menu_item_selected.connect(_on_trainable_unit_selected)
	if not Engine.is_editor_hint():
		linked_object.refresh_trainable_units()

# TODO: remove selected unit from trainable list
func _on_trainable_unit_selected(item: MenuItemBase, val: bool):
	if not val: return
	if not selected_unit_menu.get_menu_items().is_empty():
		selected_unit_menu.clear_menu_items()
	selected_unit_menu.add_menu_item(selected_unit_menu.build_menu_item(item.linked_object))
	training_menu.build_menu_items()

func _is_training_possible(training: Trait):
	if not selected_unit: return false
	return linked_object.is_valid_training_for_unit(training, selected_unit) and Game.player.money >= linked_object.training_cost

func link_object(obj: Variant, node: Node = self, recursive = false):
	super(obj, node, recursive)
	if obj is TrainingGround:
		if not is_inside_tree():
			await ready
		building_name.link_object(obj)
		trainable_units.link_object(obj.trainable_units)
		training_menu.link_object(obj.available_traits)

func _on_train_button_pressed(training: Trait):
	var dialog = DialogBox.instantiate()
	dialog.message = "Give %s the trait %s for %d money?" % [selected_unit.unit_name, training, selected_unit.hire_cost]
	dialog.add_action_button("Yes", _confirm_train.bind(selected_unit, training))
	dialog.add_cancel_button("No")
	InterfaceManager.display_interface(dialog)
	
func _confirm_train(unit: Adventurer, training: Trait):
	linked_object.give_trait_to_unit(training, unit)
	training_menu.build_menu_items()

static func instantiate(training: TrainingGround) -> TrainingGroundInterface:
	var interface = load("res://Interface/TownInterface/BuildingInterface/TrainingGroundInterface.tscn").instantiate()
	interface.link_object(training)
	return interface
