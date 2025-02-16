extends Watchable
class_name Town

var town_name: String = "Townsvillia":
	set(value):
		town_name = value
		_set("town_name", value)
		
var buildings: Array[Building] = []

func _init() -> void:
	watchable_props.append_array(["town_name"])
	var tav = Tavern.new()
	tav.building_name = "The Rusty Dragon"
	buildings.append(tav)
	var hosp = Hospital.new()
	hosp.building_name = "Sawbones Express"
	buildings.append(hosp)
