extends Node
class_name Town

var town_name: String = "Townsville":
	set(value):
		town_name = value
		property_changed.emit("town_name")
signal property_changed
		
var buildings: Array[Building] = []

func _init() -> void:
	var tav = Tavern.new()
	tav.building_name = "The Rusty Dragon"
	buildings.append(tav)
	var hosp = Hospital.new()
	buildings.append(hosp)
