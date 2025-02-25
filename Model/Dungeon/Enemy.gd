extends CombatUnit
class_name Enemy

var reward_xp: int = 100
var reward_money: int = 3

func _init() -> void:
	unit_name = "Enemy"

func combat_action():
	var target = combat.party.pick_random()
	target.take_damage(stat_atk, DamageType.PHYSICAL)
	var msg = ActivityLogMessage.new("%s dealt %d damage to %s" % [unit_name, stat_atk, target.unit_name])
	Game.activity_log.push_message(msg, false)
