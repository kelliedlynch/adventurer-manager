extends Node
class_name Building

var building_name: String = "Building Name":
	set(value):
		building_name = value
		property_changed.emit("building_name")
var building_description: String = "Description of what you can do at this building":
	set(value):
		building_description = value
		property_changed.emit("building_description")
signal property_changed

var interface = BuildingInterface
