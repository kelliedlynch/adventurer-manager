extends Resource
class_name AdventurerClass

const CURVE_BELL = preload("res://Utility/BellCurve.tres")
const CURVE_BELL_HIGH = preload("res://Utility/HighBell.tres")
const CURVE_BELL_LOW = preload("res://Utility/LowBell.tres")
const CURVE_WEIGHTED_HIGH = preload("res://Utility/WeightedHigh.tres")
const CURVE_WEIGHTED_LOW = preload("res://Utility/WeightedLow.tres")

var adventurer_class_name: String = "Commoner"
var xp_curve: Curve = load("res://Model/Adventurer/AdventurerClass/BaseLevelUpCurve.tres")



var stat_weight_overrides: Dictionary[String, float]

func _init() -> void:
	pass
	#for stat in stat_weight_overrides:
		#stat_weights[stat] = stat_weight_overrides[stat]

func combat_action(unit: Adventurer, combat: Combat):
	var target = combat.enemies.pick_random()
	unit.push_attack_msg(target, unit.stat_atk)
	target.take_damage(unit.stat_atk, Adventurer.DamageType.PHYSICAL)
	
func _to_string() -> String:
	return adventurer_class_name

static var Mage: ClassMage
static var Warrior: ClassWarrior
static var Healer: ClassHealer
static var Rogue: ClassRogue
static var all_classes: Array[AdventurerClass] = []

static func random() -> Variant:
	if all_classes.is_empty():
		Mage = ClassMage.new()
		Warrior = ClassWarrior.new()
		Healer = ClassHealer.new()
		Rogue = ClassRogue.new()
		all_classes.append_array([Mage, Warrior, Healer, Rogue])
	return all_classes.pick_random()
