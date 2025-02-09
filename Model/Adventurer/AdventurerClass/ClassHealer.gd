extends AdventurerClass
class_name ClassHealer

func _init():
	adventurer_class_name = "Healer"
	stat_overrides = {
		"stat_hp": 90,
		"stat_mp": 31,
		"stat_atk": 4,
		"stat_def": 5,
		"stat_mag": 6,
		"stat_res": 5
	}
	
	stat_level_up_overrides = {
		"stat_hp": {
			"range": range(5, 11),
			"weights": [.6, .7, 1, 1, .6, .4]
		},
		"stat_mp": {
			"range": range(3, 8),
			"weights": [.1, .6, .9, .8, .5]
		},
		"stat_atk": {
			"range": range(2, 5),
			"weights": [.4, 1, .5]
		},
		"stat_def": {
			"range": range(3, 6),
			"weights": [1, .8, .6]
		},
		"stat_mag": {
			"range": range(3, 8),
			"weights": [.2, .8, 2, 1.5, .8]
		},
		"stat_res": {
			"range": range(4, 7),
			"weights": [.5, .8, 1]
		}
	}
	super._init()
