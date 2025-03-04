extends Building
class_name TrainingGround

var trainable_units: ObservableArray = ObservableArray.new([], Adventurer)
var available_traits: Array[Trait] = []
var training_cost: int = 50

func _init() -> void:
	building_name = "Training Ground"
	building_description = "Teach old dogs new tricks. Or old adventurers new traits."
	interface = TrainingGroundInterface
	available_traits.append_array(Trait.TraitList)

func _is_trainable(unit: Adventurer) -> bool:
	if Game.player.roster.has(unit) and unit.status == Adventurer.STATUS_IDLE and unit.traits.size() < 3:
		return true
	return false
	
func give_trait_to_unit(trained: Trait, unit: Adventurer) -> void:
	if not unit.traits.has(trained) and Game.player.money >= training_cost:
		unit.traits.append(trained)
		Game.player.money -= training_cost

func refresh_trainable_units():
	var trainable = Game.player.roster.filter(_is_trainable)
	trainable_units.append_array(trainable)
