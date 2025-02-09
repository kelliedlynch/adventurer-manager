extends AdventurerClass
class_name ClassWarrior

func _init():
	adventurer_class_name = "Warrior"
	stat_overrides = {
		"stat_hp": 102,
		"stat_mp": 21,
		"stat_atk": 10,
		"stat_def": 7,
		"stat_mag": 1,
		"stat_res": 0
	}
	
	stat_level_up_overrides = {
		"stat_hp": {
			"range": range(8, 15),
			"weights": [.3, .4, .6, .7, .8, .6, .5]
		},
		"stat_mp": {
			"range": range(1, 6),
			"weights": [1, .6, .4, .4, .2]
		},
		"stat_atk": {
			"range": range(2, 6),
			"weights": [.2, .4, 1, .5]
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
