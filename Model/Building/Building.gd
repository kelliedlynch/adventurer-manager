extends Watchable
class_name Building

var building_name: String = "Building Name":
	set(value):
		building_name = value
		_set("building_name", value)
var building_description: String = "Description of what you can do at this building":
	set(value):
		building_description = value
		_set("building_description", value)

var interface = Menu

func _init() -> void:
	watchable_props.append_array(["building_name", "building_description"])
	
