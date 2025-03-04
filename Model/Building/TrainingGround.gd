extends Building
class_name TrainingGround

var trainable_units: ObservableArray = ObservableArray.new([], Adventurer)

func _init() -> void:
	building_name = "Training Ground"
	building_description = "Teach old dogs new tricks. Or old adventurers new traits."
	interface = TrainingGroundInterface

func _is_trainable(unit: Adventurer) -> bool:
	if Game.player.roster.has(unit) and unit.status == Adventurer.STATUS_IDLE and unit.traits.size() < 3:
		return true
	return false

func refresh_trainable_units():
	var trainable = Game.player.roster.filter(_is_trainable)
	trainable_units.append_array(trainable)
