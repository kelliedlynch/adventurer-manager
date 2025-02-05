@tool
extends Menu
class_name TownInterface

func _ready() -> void:
	for child in $GridContainer.get_children():
		#remove_child(child)
		child.queue_free()
	await get_tree().process_frame 
	for i in 9:
		var bldg: TownInterfaceBuilding = load("res://Interface/TownInterface/TownInterfaceBuilding.tscn").instantiate()
		bldg.building_name = "Building " + str(i + 1)
		bldg.name = bldg.building_name
		$GridContainer.add_child(bldg)
		bldg.owner = self
