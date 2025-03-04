@tool
extends Reactive
class_name TrainingGroundInterface

@onready var trainable_units: UnitListMenu = find_child("TrainableUnits")
@onready var building_name: ReactiveTextField = find_child("BuildingNameLabel")
@onready var training_menu: Menu = find_child("TrainingMenu")

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		
		var train = TrainingGround.new()
		for i in 6:
			train.trainable_units.append(AdventurerFactory.generate_random_newbie())
		link_object(train)

func link_object(obj: Variant, node: Node = self, recursive = false):
	super(obj, node, recursive)
	if obj is TrainingGround:
		if not is_inside_tree():
			await ready
		building_name.link_object(obj)
		trainable_units.link_object(obj.trainable_units)
		training_menu.link_object(obj.available_traits)


static func instantiate(training: TrainingGround) -> TrainingGroundInterface:
	var interface = load("res://Interface/TownInterface/BuildingInterface/TrainingGroundInterface.tscn").instantiate()
	interface.link_object(training)
	return interface
