@tool
extends Hazard
class_name HazardSwarms

func _init() -> void:
	hazard_name = "Swarms"
	hazard_description = "%s and %s are reduced in combat." % [Stats.stat_def.name, Stats.stat_dex.name]
	icon = load("res://Graphics/Icons/White/swarm.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.CLASS,
			countered_by = AdventurerClass.Mage,
			counter_action = CounterAction.COUNTERS
		},
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Tactician,
			counter_action = CounterAction.REDUCES_PARTY
		}
	]
