extends Hazard
class_name HazardSpooky

var morale_penalty: int = 2
var mitigated_penalty: int = 1

func _init() -> void:
	hazard_name = "Extra Spooky"
	hazard_description = "Party loses %d morale each day." % [morale_penalty]
	icon = load("res://Graphics/Icons/White/ghost.png")

func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Leader,
			counter_action = CounterAction.REDUCES_PARTY
		},
		{
			counter_type = CounterType.STAT,
			countered_by = Stats.stat_cha,
			countered_by_value = 3,
			counter_action = CounterAction.REDUCES_PARTY
		}
]

func _hook_on_end_tick(dungeon: Dungeon):
	if dungeon.party.find_custom(func(x): return x.traits.has(Trait.Leader) or x.stat_cha > 3) != -1:
		dungeon.party_morale -= mitigated_penalty
	else:
		dungeon.party_morale -= morale_penalty
