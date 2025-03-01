extends Hazard
class_name HazardSwarms

var def_penalty: int = 3
var def_penalty_mitigated: int = 1

func _init() -> void:
	hazard_name = "Swarms"
	hazard_description = "%s is reduced in combat." % [Stats.stat_def.name]
	icon = load("res://Graphics/Icons/White/swarm.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.CLASS,
			countered_by = Mage,
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
		var actions = _get_unit_counter_actions(unit)
		if actions.has(CounterAction.IGNORES):
			continue
		var buff = Buff.new()
		buff.source = self
		buff.stat_def = -def_penalty_mitigated if actions.has(CounterAction.REDUCES) else -def_penalty
		unit.buffs.append(buff)

#func after_combat_action(dungeon: Dungeon):
	#remove_own_buffs(dungeon.party)
