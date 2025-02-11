@tool
extends Interface
class_name TownInterface

@onready var name_field: LabeledField = find_child("TownName")
@onready var building_grid: GridContainer = find_child("Buildings")

var model: Town

func _ready() -> void:
	for child in building_grid.get_children():
		#remove_child(child)
		child.queue_free()
	await get_tree().process_frame 
	if Engine.is_editor_hint() or get_tree().current_scene == self:
		for i in 9:
			var bldg: TownInterfaceBuilding = TownInterfaceBuilding.instantiate()
			building_grid.add_child(bldg)
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
	var menu = building.interface.instantiate(building)
	add_child(menu)

static func instantiate(town: Town) -> TownInterface:
	var menu = load("res://Interface/TownInterface/TownInterface.tscn").instantiate()
	menu.model = town
	return menu
