extends Resource
class_name Town

var town_name: String = "Generic Town"
		
var buildings: Array[Building] = []

func _init() -> void:
	var tav = Tavern.new()
	tav.building_name = "The Rusty Dragon"
	buildings.append(tav)
	var hosp = Hospital.new()
	hosp.building_name = "Sawbones Express"
	buildings.append(hosp)
