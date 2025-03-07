extends Hazard
class_name HazardRoughTerrain

var time_penalty: int = 2
var mitigated_penalty: int = 1
var def_penalty: int = 2
var def_penalty_mitigated: int = 1

func _init() -> void:
	hazard_name = "Rough Terrain"
	hazard_description = "Quest takes an additional %d day(s). %s reduced by %s in combat." % [time_penalty, Stats.stat_def.abbreviation, def_penalty]
	icon = load("res://Graphics/Icons/White/falling_rocks.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Trailblazer,
			counter_action = CounterAction.COUNTERS
		},
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Cautious,
			counter_action = CounterAction.REDUCES
		}
	]

func _hook_on_begin_combat(dungeon: Dungeon):
	if get_mitigated_state(dungeon) == MitigatedState.INACTIVE: return
	for unit in dungeon.party:
		var actions = _get_unit_counter_actions(unit)
		if actions.has(CounterAction.IGNORES):
			continue
		var buff = Buff.new()
		buff.source = self
		buff.stat_def = -def_penalty_mitigated if actions.has(CounterAction.REDUCES) else -def_penalty
		unit.buffs.append(buff)
