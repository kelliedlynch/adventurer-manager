extends AdventurerClass
class_name ClassMage

var spell_mp_cost: int = 3

func _init():
	adventurer_class_name = "Mage"
	stat_overrides = {
		"stat_hp": 8,
		"stat_mp": 8,
		"stat_atk": 4,
		"stat_def": 5,
		"stat_mag": 6,
		"stat_res": 5,
		"stat_dex": 2,
		"stat_cha": 4,
		"stat_luk": 0
	}
	
	stat_level_up_overrides = {
		"stat_hp": {
			"range": range(3, 7),
			"weights": [.6, .7, 1, .4]
		},
		"stat_mp": {
			"range": range(3, 7),
			"weights": [.1, .6, 1, .5]
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
			"range": range(2, 6),
			"weights": [.2, .8, 2, .5]
		},
		"stat_res": {
			"range": range(3, 6),
			"weights": [.5, .8, 1]
		}
	}
	super._init()

func combat_action(unit: Adventurer, combat: Combat):
	if unit.current_mp >= spell_mp_cost:
		var target = combat.enemies.pick_random()
		target.take_damage(unit.stat_mag)
		unit.current_mp -= spell_mp_cost
		return
	super(unit, combat)
