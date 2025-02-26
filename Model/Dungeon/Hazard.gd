extends Resource
class_name Hazard

var hazard_name: String = "Hazard"
var hazard_description: String = "Makes stuff more dangerous. Here's some more text for tooltip size testing purposes."
var icon: Texture2D = load("res://Graphics/Icons/White/warning.png")

var counters: Array[Dictionary]:
	get:
		return _get_counters()

func get_mitigated_state(dungeon: Dungeon):
	var mit_state = MitigatedState.ACTIVE
	var countering_party_members = []
	var check_units = dungeon.staged
	if dungeon.questing:
		check_units = dungeon.party
	for counter in counters:
		for unit in check_units:
			var actions = unit_counter_actions(unit)
			if actions.is_empty():
				continue
			if actions.has(CounterAction.COUNTERS):
				return MitigatedState.INACTIVE
			if actions.has(CounterAction.IGNORES) or actions.has(CounterAction.REDUCES_PARTY) or actions.has(CounterAction.REDUCES):
				if not countering_party_members.has(unit):
					countering_party_members.append(unit)
			mit_state = MitigatedState.PARTIAL
		if mit_state == MitigatedState.ACTIVE:
			continue
		if countering_party_members.size() == check_units.size():
			return MitigatedState.INACTIVE
	return mit_state
	
func unit_counter_actions(unit: Adventurer) -> Array[CounterAction]:
	var counter_actions: Array[CounterAction] = []
	for counter in counters:
		match counter.counter_type:
			Hazard.CounterType.CLASS:
				if unit.adventurer_class != counter.countered_by:
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
			countered_by = AdventurerClass.Mage,
			counter_action = CounterAction.REDUCES_PARTY
		},
		{
			counter_type = CounterType.CLASS,
			countered_by = AdventurerClass.Warrior,
			counter_action = CounterAction.REDUCES_PARTY
		},
		{
			counter_type = CounterType.CLASS,
			countered_by = AdventurerClass.Healer,
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
		},
		{
			counter_type = CounterType.STAT,
			countered_by = Stats.stat_luk,
			countered_by_value = 1,
			counter_action = CounterAction.REDUCES
		}
]

func before_quest_action(_dungeon: Dungeon):
	pass
	
func after_quest_action(_dungeon: Dungeon):
	pass
	
func per_tick_action(_dungeon: Dungeon):
	pass

func before_combat_action(_dungeon: Dungeon):
	pass

func after_combat_action(dungeon: Dungeon):
	# TODO: currently no way to distinguish between combat- and dungeon-duration buffs. Fix that.
	# TODO: I think combat.party might not include people who have died and still need buffs removed
	remove_own_buffs(dungeon.party)

func per_combat_round_action(_dungeon: Dungeon):
	pass

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
