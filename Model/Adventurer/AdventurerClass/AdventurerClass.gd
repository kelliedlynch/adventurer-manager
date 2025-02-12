extends Resource
class_name AdventurerClass


# TODO: AdventurerClasses should be singletons--the class won't have different instances for different units
var adventurer_class_name: String = "Commoner"
var xp_curve: Curve = load("res://Model/Adventurer/AdventurerClass/BaseLevelUpCurve.tres")

var stat_level_up_values: Dictionary = {
	"stat_hp": {
		"range": range(3, 10),
		"curve": load("res://Utility/BellCurve.tres")
	},
	"stat_mp": {
		"range": range(2, 5),
		"curve": load("res://Utility/BellCurve.tres")
	},
	"stat_atk": {
		"range": range(1, 4),
		"curve": load("res://Utility/BellCurve.tres")
	},
	"stat_def": {
		"range": range(1, 4),
		"curve": load("res://Utility/BellCurve.tres")
	},
	"stat_mag": {
		"range": range(1, 4),
		"curve": load("res://Utility/BellCurve.tres")
	},
	"stat_res": {
		"range": range(1, 4),
		"curve": load("res://Utility/BellCurve.tres")
	},
	"stat_dex": {
		"range": range(1, 4),
		"curve": load("res://Utility/BellCurve.tres")
	},
	"stat_cha": {
		"range": range(1, 4),
		"curve": load("res://Utility/BellCurve.tres")
	},
	"stat_luk": {
		"range": range(0, 4),
		"curve": load("res://Utility/BellCurve.tres")
	}
}

var stat_overrides: Dictionary
var stat_level_up_overrides: Dictionary

func _init() -> void:
	for stat in stat_level_up_overrides:
		for key in stat_level_up_overrides[stat]:
			stat_level_up_values[stat][key] = stat_level_up_overrides[stat][key]

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
