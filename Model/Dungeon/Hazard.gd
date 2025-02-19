@tool
extends Resource
class_name Hazard

var hazard_name: String = "Hazard"
var hazard_description: String = "Makes stuff more dangerous."
var icon: Texture2D = load("res://Graphics/Icons/White/warning.png")

var counters: Array[Dictionary]:
	get:
		return _get_counters()

func get_mitigated_state(dungeon: Dungeon):
	var mit_state = MitigatedState.ACTIVE
	var countering_party_members = []
	for counter in counters:
		
		for unit in dungeon.party:
			var actions = unit_counter_actions(unit)
			if actions.is_empty():
				continue
			if actions.has(CounterAction.COUNTERS):
				return MitigatedState.INACTIVE
			if actions.has(CounterAction.IGNORES):
				if not countering_party_members.has(unit):
					countering_party_members.append(unit)
			mit_state = MitigatedState.PARTIAL
		if mit_state == MitigatedState.ACTIVE:
			continue
		if countering_party_members.size() == dungeon.party.size():
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
				if unit.get(counter.countered_by.prop_name < counter.countered_by_value):
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

func per_quest_action(_dungeon: Dungeon):
	pass
	
func per_tick_action(_dungeon: Dungeon):
	pass

func before_combat_action(_dungeon: Dungeon):
	pass

func after_combat_action(_dungeon: Dungeon):
	pass

func per_combat_round_action(_dungeon: Dungeon):
	pass

static var Cold: HazardCold = HazardCold.new()
static var Swarms: HazardSwarms = HazardSwarms.new()
static var RoughTerrain: HazardRoughTerrain = HazardRoughTerrain.new()

static func random() -> Hazard:
	var list = [Cold, Swarms, RoughTerrain]
	print(list)
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
