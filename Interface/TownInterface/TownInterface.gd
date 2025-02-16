@tool
extends Interface
class_name TownInterface

@onready var name_field: ReactiveField = find_child("TownName")
@onready var building_grid: GridContainer = find_child("Buildings")

var town: Town = null:
	set(value):
		town = value
		if town:
			if not is_inside_tree():
				await ready
			watch_reactive_fields(town, self)

func _ready() -> void:
	for child in building_grid.get_children():
		child.queue_free()
	if not is_inside_tree():
		await ready
	if Engine.is_editor_hint() or get_tree().current_scene == self:
		town = Town.new()
	if town:
		for building in town.buildings:
			var bldg = TownInterfaceBuilding.instantiate(building)
			building_grid.add_child(bldg)
			bldg.enter_button.pressed.connect(_open_building_menu.bind(building))
	super()

func _open_building_menu(building: Building):
	var menu = building.interface.instantiate(building)
	add_child(menu)

static func instantiate(town: Town) -> TownInterface:
	var menu = load("res://Interface/TownInterface/TownInterface.tscn").instantiate()
	menu.town = town
	return menu
