extends Hazard
class_name HazardSwarms

func _init() -> void:
	hazard_name = "Swarms"
	hazard_description = "Something bad, I don't know yet"
	icon = load("res://Graphics/Icons/White/swarm.png")
	counters = [
		{
			"counter_type": CounteredBy.CLASS,
			"countered_by": AdventurerClass.Mage,
			"counter_action": CounterType.COUNTERS
		},
		{
			"counter_type": CounteredBy.TRAIT,
			"countered_by": Trait.Tactician,
			"counter_action": CounterType.REDUCES_PARTY
		}
	]
