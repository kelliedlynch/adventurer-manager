extends AdventurerClassBase
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
		},
		"stat_mp": {
			"range": range(3, 7),
		},
		"stat_atk": {
			"range": range(1, 4),
		},
		"stat_def": {
			"range": range(1, 4),
		},
		"stat_mag": {
			"range": range(2, 6),
		},
		"stat_res": {
			"range": range(3, 6),
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
