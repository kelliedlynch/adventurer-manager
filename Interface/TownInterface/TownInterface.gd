@tool
extends Menu
class_name TownInterface

@onready var name_field: LabeledField = $VBoxContainer/TownName
@onready var building_grid: GridContainer = $VBoxContainer/GridContainer

var model: Town

func _ready() -> void:
	for child in building_grid.get_children():
		#remove_child(child)
		child.queue_free()
	await get_tree().process_frame 
	if get_tree().current_scene == self or Engine.is_editor_hint():
		for i in 9:
			var bldg: TownInterfaceBuilding = TownInterfaceBuilding.instantiate()
			bldg.building_name = "Building " + str(i + 1)
			bldg.name = bldg.building_name
			building_grid.add_child(bldg)
			bldg.owner = self
	else:
		name_field.watch_object(model)
		for building in model.buildings:
			var bldg = TownInterfaceBuilding.instantiate()
			building_grid.add_child(bldg)
			#await bldg.ready
			bldg.name_label.watch_object(building)
			bldg.description_label.watch_object(building)
			bldg.enter_button.pressed.connect(_open_building_menu.bind(building))

func _open_building_menu(building: Building):
	var menu = building.interface.instantiate()
	menu.model = building
	add_child(menu)

static func instantiate() -> TownInterface:
	return load("res://Interface/TownInterface/TownInterface.tscn").instantiate()
