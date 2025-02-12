extends AdventurerClass
class_name ClassWarrior

func _init():
	adventurer_class_name = "Warrior"
	stat_overrides = {
		"stat_hp": 16,
		"stat_mp": 2,
		"stat_atk": 7,
		"stat_def": 6,
		"stat_mag": 1,
		"stat_res": 0,
		"stat_dex": 3,
		"stat_luk": 0
	}
	
	stat_level_up_overrides = {
		"stat_hp": {
			"range": range(6, 10),
			"weights": [.3, .6, .1, .6, .3]
		},
		"stat_mp": {
			"range": range(1, 4),
			"weights": [1, .4, .1]
		},
		"stat_atk": {
			"range": range(2, 5),
			"weights": [.2, .5, 1]
		},
		"stat_def": {
			"range": range(1, 4),
			"weights": [.1, 1.5, 3]
		},
		"stat_mag": {
			"range": range(1, 4),
			"weights": [3, .2, .1]
		},
		"stat_res": {
			"range": range(1, 4),
			"weights": [2, .8, .3]
		}
	}
	super._init()

func combat_action(unit: Adventurer, combat: Combat):
	super(unit, combat)
