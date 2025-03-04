extends Resource
class_name Town

var town_name: String = "Generic Town"
		
var buildings: ObservableArray = ObservableArray.new([], Building)

func _init() -> void:
	var tav = Tavern.new()
	tav.building_name = "The Rusty Dragon"
	buildings.append(tav)
	var hosp = Hospital.new()
	hosp.building_name = "Sawbones Express"
	buildings.append(hosp)
	var train = TrainingGround.new()
	train.building_name = "Adventurer School"
	buildings.append(train)
