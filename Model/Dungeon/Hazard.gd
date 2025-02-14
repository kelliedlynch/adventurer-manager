extends Resource
class_name Hazard

var hazard_name: String = "Hazard"
var hazard_description: String = "Makes stuff more dangerous."
var icon: Texture2D = load("res://Graphics/Icons/White/warning.png")

var counters: Array[Dictionary] = [
	{
		"countered_by": ClassMage,
		"counter_type": CounterType.REDUCES_PARTY,
	}
]

func get_mitigated_state(_dungeon: Dungeon):
	pass

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
