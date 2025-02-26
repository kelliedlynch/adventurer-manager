extends Resource
class_name Combat

var party: Array[Adventurer] = []
var enemies: Array[Enemy] = []
var participants: Array[CombatUnit]:
	get:
		var p: Array[CombatUnit] = []
		p.append_array(party)
		p.append_array(enemies)
		return p
var reward_xp: int = 0
var reward_money: int = 0

signal combat_ended

func add_unit(unit: CombatUnit):
	if unit is Adventurer:
		party.append(unit)
	elif unit is Enemy:
		enemies.append(unit)
	unit.combat = self

func remove_unit(unit: CombatUnit):
	combat_ended.connect(unit.set.bind("combat", null), CONNECT_ONE_SHOT)
	if unit is Adventurer:
		party.erase(unit)
	elif unit is Enemy:
		reward_xp += unit.reward_xp
		reward_money += unit.reward_money
		enemies.erase(unit)

func _perform_combat_round():
	for unit in participants:
		if participants.has(unit):
			unit.combat_action()
		if party.is_empty() or enemies.is_empty():
			return

func _end_combat():
	for conn in combat_ended.get_connections():
		combat_ended.disconnect(conn.callable)

func run_combat() -> int:
	participants.sort_custom(func(a, b): return a.stat_dex > b.stat_dex)
	for i in 100:
		_perform_combat_round()
		if party.is_empty():
			_end_combat()
			return RESULT_LOSS
		if enemies.is_empty():
			var xp = floor(reward_xp / float(party.size()))
			party.all(func(x): x.add_experience(xp))
			_end_combat()
			return RESULT_WIN
	reward_xp = 0
	reward_money = 0
	_end_combat()
	return RESULT_STALEMATE

enum {
	RESULT_WIN,
	RESULT_LOSS,
	RESULT_STALEMATE
}
