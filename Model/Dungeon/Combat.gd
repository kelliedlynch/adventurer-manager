extends Resource
class_name Combat

var party: Array[Adventurer] = []
var alive_party: Array[Adventurer] = []:
	get: return party.filter(func(x): return not x.status & CombatUnit.STATUS_DEAD)
		
var enemies: Array[Enemy] = []
var alive_enemies: Array[Enemy] = []:
	get: return enemies.filter(func(x): return not x.status & CombatUnit.STATUS_DEAD)
	
var participants: Array[CombatUnit]:
	get:
		var p: Array[CombatUnit] = []
		p.append_array(alive_party + alive_enemies)
		p.shuffle()
		return p
		
var reward_xp: int = 0
var reward_money: int = 0




signal combat_ended

func add_unit(unit: CombatUnit):
	if unit is Adventurer:
		party.append(unit)
	elif unit is Enemy:
		enemies.append(unit)
		reward_xp += unit.reward_xp
		reward_money += unit.reward_money

func remove_unit(unit: CombatUnit):
	#combat_ended.connect(unit.set.bind("combat", null), CONNECT_ONE_SHOT)
	if unit is Adventurer:
		party.erase(unit)
	elif unit is Enemy:
		enemies.erase(unit)
	reward_xp += unit.reward_xp
	reward_money += unit.reward_money

func _perform_combat_round():
	for unit in participants:
		unit.combat_action(self)

func _end_combat():
	for conn in combat_ended.get_connections():
		combat_ended.disconnect(conn.callable)
	#for unit in participants:
		#if "_hook_on_end_combat" in unit:
			#unit._hook_on_end_combat(self)

func run_combat() -> int:
	#for unit in participants:
		#if "_hook_on_begin_combat" in unit:
			#unit._hook_on_begin_combat(self)
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
	_end_combat()
	return RESULT_STALEMATE

enum {
	RESULT_WIN,
	RESULT_LOSS,
	RESULT_STALEMATE
}
