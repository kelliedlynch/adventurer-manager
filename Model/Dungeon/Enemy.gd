extends Resource
class_name Enemy

var stat_hp: int = 10
var curr_hp: int = stat_hp
var stat_atk: int = 5
var reward_xp: int = 10
var reward_money: int = 10

signal enemy_died

func combat_action(combat: Combat):
	var target = combat.party.pick_random()
	target.take_damage(stat_atk)

func take_damage(dmg: int):
	curr_hp -= dmg
	if curr_hp <= 0:
		enemy_died.emit(self)
