extends Resource
class_name Hazard

var hazard_name: String = "Hazard"
var hazard_description: String = "Makes stuff more dangerous. Here's some more text for tooltip size testing purposes."
var icon: Texture2D = load("res://Graphics/Icons/White/warning.png")

var counters: Array[Dictionary]:
	get:
		return _get_counters()

func get_mitigated_state(dungeon: Dungeon):
	var immune_party_members = []
	var partially_mitigated = false
	var check_units = dungeon.staged
	if dungeon.questing:
		check_units = dungeon.party
	if check_units.is_empty(): return MitigatedState.ACTIVE
	for counter in counters:
		for unit in check_units:
			var actions = _get_unit_counter_actions(unit)
			if actions.is_empty():
				continue
			if actions.has(CounterAction.COUNTERS):
				return MitigatedState.INACTIVE
			if actions.has(CounterAction.IGNORES):
				if not immune_party_members.has(unit):
					immune_party_members.append(unit)
				partially_mitigated = true
			if actions.has(CounterAction.REDUCES_PARTY) or actions.has(CounterAction.REDUCES):
				partially_mitigated = true
		if immune_party_members.size() == check_units.size():
			return MitigatedState.INACTIVE
	return MitigatedState.PARTIAL if partially_mitigated else MitigatedState.ACTIVE
	
func _get_unit_counter_actions(unit: Adventurer) -> Array[CounterAction]:
	var counter_actions: Array[CounterAction] = []
	for counter in counters:
		match counter.counter_type:
			Hazard.CounterType.CLASS:
				if not is_instance_of(unit, counter.countered_by):
					continue
			Hazard.CounterType.STAT:
				if unit.get(counter.countered_by.property_name) <= counter.countered_by_value:
					continue
			Hazard.CounterType.SKILL:
				pass
			Hazard.CounterType.TRAIT:
				if not unit.traits.has(counter.countered_by):
					continue
		if not counter_actions.has(counter.counter_action):
			counter_actions.append(counter.counter_action)
	return counter_actions

func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.CLASS,
			countered_by = Mage,
			counter_action = CounterAction.REDUCES_PARTY
		},
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Robust,
			counter_action = CounterAction.IGNORES
		},
		{
			counter_type = CounterType.STAT,
			countered_by = Stats.stat_atk,
			countered_by_value = 10,
			counter_action = CounterAction.COUNTERS
		}
]

func _hook_on_begin_quest(_dungeon: Dungeon):
	pass
	
func _hook_on_end_quest(_dungeon: Dungeon):
	pass
	
func _hook_on_end_tick(_dungeon: Dungeon):
	pass

func _hook_on_begin_combat(_dungeon: Dungeon):
	pass

func _hook_on_end_combat(dungeon: Dungeon):
	# TODO: currently no way to distinguish between combat- and dungeon-duration buffs. Fix that.
	# TODO: I think combat.party might not include people who have died and still need buffs removed
	remove_own_buffs(dungeon.party)

func remove_own_buffs(party):
	for unit in party:
		var to_remove = unit.buffs.filter(func(x): return x.source == self)
		for b in to_remove:
			unit.buffs.erase(b)

static var Cold: HazardCold = HazardCold.new()
static var Swarms: HazardSwarms = HazardSwarms.new()
static var RoughTerrain: HazardRoughTerrain = HazardRoughTerrain.new()
static var Traps: HazardTraps = HazardTraps.new()

static func random() -> Hazard:
	var list = [Cold, Swarms, RoughTerrain, Traps]
	return list.pick_random()



enum CounterAction {
	COUNTERS,
	REDUCES_PARTY,
	REDUCES,
	IGNORES
}

enum CounterType {
	CLASS,
	TRAIT,
	SKILL,
	STAT
}

enum MitigatedState {
	ACTIVE,
	PARTIAL,
	INACTIVE
}
