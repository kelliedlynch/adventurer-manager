extends Resource
class_name AdventurerClass


# TODO: AdventurerClasses should be singletons--the class won't have different instances for different units
var adventurer_class_name: String = "Commoner"
var xp_curve: Curve = load("res://Model/Adventurer/AdventurerClass/BaseLevelUpCurve.tres")

var stat_level_up_values: Dictionary = {
	"stat_hp": {
		"range": range(3, 10),
		"weights": [.5, .6, .8, 1, .8, .6, .5]
	},
	"stat_mp": {
		"range": range(2, 5),
		"weights": [.4, 1, .7, .3]
	},
	"stat_atk": {
		"range": range(1, 4),
		"weights": [.5, 1, .5]
	},
	"stat_def": {
		"range": range(1, 4),
		"weights": [.5, 1, .5]
	},
	"stat_mag": {
		"range": range(1, 4),
		"weights": [.5, 1, .5]
	},
	"stat_res": {
		"range": range(1, 4),
		"weights": [.5, 1, .5]
	},
	"stat_dex": {
		"range": range(1, 4),
		"weights": [.5, 1, .5]
	},
	"stat_cha": {
		"range": range(1, 4),
		"weights": [.5, 1, .5]
	},
	"stat_luk": {
		"range": range(0, 4),
		"weights": [2, .1, .05, .01]
	}
}

var stat_overrides: Dictionary
var stat_level_up_overrides: Dictionary

func _init() -> void:
	for stat in stat_level_up_overrides:
		stat_level_up_values[stat] = stat_level_up_overrides[stat]

func combat_action(unit: Adventurer, combat: Combat):
	var target = combat.enemies.pick_random()
	target.take_damage(unit.stat_atk)

func _to_string() -> String:
	return adventurer_class_name

static func random() -> Variant:
	var classes = [
		ClassWarrior, ClassMage, ClassHealer
	]
	return classes.pick_random()
