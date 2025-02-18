extends Resource
class_name Hazard

var hazard_name: String = "Hazard"
var hazard_description: String = "Makes stuff more dangerous."
var icon: Texture2D = load("res://Graphics/Icons/White/warning.png")

var counters: Array[Dictionary] = [
		{
			counter_type = CounteredBy.CLASS,
			countered_by = AdventurerClass.Mage,
			counter_action = CounterType.REDUCES_PARTY
		},
		{
			counter_type = CounteredBy.TRAIT,
			countered_by = Trait.Robust,
			counter_action = CounterType.IGNORES
		},
		{
			counter_type = CounteredBy.STAT,
			countered_by = Stats.stat_atk,
			countered_by_value = 10,
			counter_action = CounterType.COUNTERS
		},
		{
			counter_type = CounteredBy.STAT,
			countered_by = Stats.stat_luk,
			countered_by_value = 1,
			counter_action = CounterType.REDUCES
		}
]

func get_mitigated_state(dungeon: Dungeon):
	var mit_state = MitigatedState.ACTIVE
	for counter in counters:
		var countering_party_members = []
		var party = dungeon.party.duplicate()
		party.append_array(dungeon.staged)
		match counter.counter_type:
			Hazard.CounteredBy.CLASS:
				countering_party_members = party.filter(func(x): return x.adventurer_class == counter.countered_by)
			Hazard.CounteredBy.STAT:
				countering_party_members = party.filter(func(x): return x.get(counter.countered_by.prop_name) >= counter.countered_by_value)
			Hazard.CounteredBy.SKILL:
				pass
			Hazard.CounteredBy.TRAIT:
				var a = counter.countered_by
				countering_party_members = party.filter(func(x): return x.traits.has(counter.countered_by))
		
		if countering_party_members.is_empty(): 
			continue
		
		match counter.counter_action:
			Hazard.CounterType.COUNTERS:
				mit_state = MitigatedState.INACTIVE
			Hazard.CounterType.REDUCES_PARTY:
				mit_state = MitigatedState.PARTIAL
			Hazard.CounterType.IGNORES:
				mit_state = MitigatedState.INACTIVE if countering_party_members.size() == party.size() else MitigatedState.PARTIAL
			Hazard.CounterType.REDUCES:
				mit_state = MitigatedState.PARTIAL
				
		if mit_state == MitigatedState.INACTIVE:
			return mit_state
	return mit_state

func per_quest_action(_dungeon: Dungeon):
	pass
	
func per_tick_action(_dungeon: Dungeon):
	pass

func per_combat_action(_dungeon: Dungeon):
	pass

func per_combat_round_action(_dungeon: Dungeon):
	pass


enum CounterType {
	COUNTERS,
	REDUCES_PARTY,
	REDUCES,
	IGNORES
}

enum CounteredBy {
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
