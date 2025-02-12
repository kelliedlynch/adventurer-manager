extends AdventurerClass
class_name ClassHealer

var heal_mp_cost: int = 3

func _init():
	adventurer_class_name = "Healer"
	stat_overrides = {
		"stat_hp": 13,
		"stat_mp": 7,
		"stat_atk": 4,
		"stat_def": 5,
		"stat_mag": 6,
		"stat_res": 5,
		"stat_dex": 2,
		"stat_cha": 5,
		"stat_luk": 0
	}
	
	stat_level_up_overrides = {
		"stat_hp": {
			"range": range(5, 9),
			"weights": [.6, .7, 1, .4]
		},
		"stat_mp": {
			"range": range(3, 6),
			"weights": [.1, .6, 1]
		},
		"stat_atk": {
			"range": range(2, 5),
			"weights": [.7, 1, .5]
		},
		"stat_def": {
			"range": range(3, 6),
			"weights": [1, .8, .6]
		},
		"stat_mag": {
			"range": range(1, 4),
			"weights": [.2, .6, 1, .8]
		},
		"stat_res": {
			"range": range(4, 7),
			"weights": [.5, .8, 1]
		}
	}
	super._init()

func combat_action(unit: Adventurer, combat: Combat):
	if unit.current_mp >= heal_mp_cost:
		var heal_target = combat.party.find_custom(func(x): return x.stat_hp - x.current_hp >= unit.stat_mag)
		if heal_target != -1:
			combat.party[heal_target].current_hp += unit.stat_mag
			unit.current_mp -= heal_mp_cost
			return
	super(unit, combat)
