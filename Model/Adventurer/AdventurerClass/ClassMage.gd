extends AdventurerClass
class_name ClassMage

func _init():
	adventurer_class_name = "Mage"
	stat_overrides = {
		"stat_hp": 62,
		"stat_mp": 41,
		"stat_atk": 4,
		"stat_def": 5,
		"stat_mag": 6,
		"stat_res": 5
	}
	
	stat_level_up_overrides = {
		"stat_hp": {
			"range": range(3, 9),
			"weights": [.6, .7, 1, 1, .6, .4]
		},
		"stat_mp": {
			"range": range(4, 9),
			"weights": [.1, .6, .9, .8, .5]
		},
		"stat_atk": {
			"range": range(1, 4),
			"weights": [3, 1.2, .5]
		},
		"stat_def": {
			"range": range(1, 4),
			"weights": [1, .8, .6]
		},
		"stat_mag": {
			"range": range(4, 9),
			"weights": [.2, .8, 2, 1.5, .8]
		},
		"stat_res": {
			"range": range(3, 6),
			"weights": [.5, .8, 1]
		}
	}
	super._init()
