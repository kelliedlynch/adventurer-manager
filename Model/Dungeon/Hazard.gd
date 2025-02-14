extends Resource
class_name Hazard

var hazard_name: String = "Hazard"
var hazard_description: String = "Makes stuff more dangerous."
var icon: Texture2D

var counters: Array[Dictionary] = [
	{
		"countered_by": ClassMage,
		"counter_type": REDUCES_PARTY,
		"per_quest_action": func(x): return,
		"per_tick_action": func(x): return,
		"per_combat_action": func(x): return,
		"per_combat_round_action": func(x): return,
	}
]

func per_quest_action(dungeon: Dungeon):
	pass
	
func per_tick_action(dungeon: Dungeon):
	pass

func per_combat_action(dungeon: Dungeon):
	pass

func per_combat_round_action(dungeon: Dungeon):
	pass


enum {
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
