extends Hazard
class_name HazardSwarms

var def_penalty: int = 3
var dex_penalty: int = 2
var def_penalty_mitigated: int = 1
var dex_penalty_mitigated: int = 1

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

func before_combat_action(dungeon: Dungeon):
	if get_mitigated_state(dungeon) == MitigatedState.INACTIVE: return
	for unit in dungeon.party:
		var actions = unit_counter_actions(unit)
		if actions.has(CounterAction.IGNORES):
			continue
		var buff = Buff.new()
		buff.source = self
		buff.stat_def = -def_penalty_mitigated if actions.has(CounterAction.REDUCES) else -def_penalty
		buff.stat_dex = -dex_penalty_mitigated if actions.has(CounterAction.REDUCES) else -dex_penalty
		unit.buffs.append(buff)

#func after_combat_action(dungeon: Dungeon):
	#remove_own_buffs(dungeon.party)
