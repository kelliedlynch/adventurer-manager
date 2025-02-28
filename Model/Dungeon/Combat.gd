extends Resource
class_name Combat

var party: Array[Adventurer] = []
var alive_party: Array[Adventurer] = []:
	get: return party.filter(func(x): return x.status & CombatUnit.STATUS_DEAD)
		
var enemies: Array[Enemy] = []
var alive_enemies: Array[Enemy] = []:
	get: return enemies.filter(func(x): return x.status & CombatUnit.STATUS_DEAD)
	
var participants: Array[CombatUnit]:
	get:
		var p = alive_party + alive_enemies
		p.shuffle()
		return p
		
var reward_xp: int = 0
var reward_money: int = 0

var hooks = {
	begin_quest = [],
	begin_tick = [],
	begin_combat = [],
	begin_round = [],
	before_combat_action = [],
	after_combat_action = [],
	before_take_damage = [],
	after_take_damage = [],
	adventurer_died = [],
	enemy_died = [],
	end_round = [],
	end_combat = [],
	end_tick = [],
	end_quest = []
}


signal combat_ended

func add_unit(unit: CombatUnit):
	if unit is Adventurer:
		party.append(unit)
	elif unit is Enemy:
		enemies.append(unit)
	#unit.died.connect(remove_unit)
	#unit.combat = self

func remove_unit(unit: CombatUnit):
	#combat_ended.connect(unit.set.bind("combat", null), CONNECT_ONE_SHOT)
	if unit is Adventurer:
		party.erase(unit)
	elif unit is Enemy:
		reward_xp += unit.reward_xp
		reward_money += unit.reward_money
		enemies.erase(unit)

func _perform_combat_round():
	for unit in participants:
		unit.combat_action(self)

func _end_combat():
	for conn in combat_ended.get_connections():
		combat_ended.disconnect(conn.callable)

func run_combat() -> int:
	for i in 100:
		_perform_combat_round()
		if alive_party.is_empty():
			_end_combat()
			return RESULT_LOSS
		if alive_enemies.is_empty():
			var xp = floor(reward_xp / float(alive_party.size()))
			alive_party.map(func(x): x.add_experience(xp))
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
