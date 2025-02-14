extends CombatUnit
class_name Enemy

var reward_xp: int = 10
var reward_money: int = 3

func combat_action():
	var target = combat.party.pick_random()
	target.take_damage(stat_atk)
