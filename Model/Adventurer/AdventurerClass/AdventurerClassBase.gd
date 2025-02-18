extends Resource
class_name AdventurerClassBase

const CURVE_BELL = preload("res://Utility/BellCurve.tres")
const CURVE_BELL_HIGH = preload("res://Utility/HighBell.tres")
const CURVE_BELL_LOW = preload("res://Utility/LowBell.tres")
const CURVE_WEIGHTED_HIGH = preload("res://Utility/WeightedHigh.tres")
const CURVE_WEIGHTED_LOW = preload("res://Utility/WeightedLow.tres")

var adventurer_class_name: String = "Commoner"
var xp_curve: Curve = load("res://Model/Adventurer/AdventurerClass/BaseLevelUpCurve.tres")

var stat_level_up_values: Dictionary = {
	"stat_hp": {
		"range": range(3, 10),
		"curve": CURVE_BELL
	},
	"stat_mp": {
		"range": range(2, 5),
		"curve": CURVE_BELL
	},
	"stat_atk": {
		"range": range(1, 4),
		"curve": CURVE_BELL
	},
	"stat_def": {
		"range": range(1, 4),
		"curve": CURVE_BELL
	},
	"stat_mag": {
		"range": range(1, 4),
		"curve": CURVE_BELL
	},
	"stat_res": {
		"range": range(1, 4),
		"curve": CURVE_BELL
	},
	"stat_dex": {
		"range": range(1, 4),
		"curve": CURVE_BELL
	},
	"stat_cha": {
		"range": range(1, 4),
		"curve": CURVE_BELL
	},
	"stat_luk": {
		"range": range(0, 1),
		"curve": CURVE_WEIGHTED_LOW
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
