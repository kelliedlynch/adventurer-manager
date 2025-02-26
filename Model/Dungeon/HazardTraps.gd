extends Hazard
class_name HazardTraps

var trap_damage: int = 5

func _init() -> void:
	hazard_name = "Traps"
	hazard_description = "Chance of taking serious damage between combats."
	#icon = load("res://Graphics/Icons/White/swarm.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.CLASS,
			countered_by = AdventurerClass.Rogue,
			counter_action = CounterAction.COUNTERS
		},
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.EagleEye,
			counter_action = CounterAction.REDUCES_PARTY
		},
		{
			counter_type = CounterType.STAT,
			countered_by = Stats.stat_luk,
			countered_by_value = 3,
			counter_action = CounterAction.IGNORES
		},
		{
			counter_type = CounterType.STAT,
			countered_by = Stats.stat_dex,
			countered_by_value = 8,
			counter_action = CounterAction.REDUCES
		}
]
