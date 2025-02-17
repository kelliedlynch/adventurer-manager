extends Watchable
class_name CombatUnit

var combat: Combat

var buffs = []

var unit_name: String = "":
	set(value):
		unit_name = value
		_set("unit_name", value)

var level: int = 0:
	set(value):
		level = value
		_set("level", value)

var stat_hp: int:
	set(value):
		stat_hp = value
		_set("stat_hp", value)
		
var calc_hp: int:
	get:
		return _get_calculated_stat("calc_hp")
	set(value):
		push_error("can't set calculated stats")

var current_hp: int:
	set(value):
		current_hp = value
		_set("current_hp", value)

var stat_mp: int:
	set(value):
		stat_mp = value
		_set("stat_mp", value)

var calc_mp: int:
	get:
		return _get_calculated_stat("calc_mp")
	set(value):
		push_error("can't set calculated stats")

var current_mp: int :
	set(value):
		current_mp = value
		_set("current_mp", value)
		
var stat_atk: int:
	set(value):
		stat_atk = value
		_set("stat_atk", value)
		
var calc_atk: int:
	get:
		return _get_calculated_stat("calc_atk")
	set(value):
		push_error("can't set calculated stats")
		
var stat_def: int:
	set(value):
		stat_def = value
		_set("stat_def", value)

var calc_def: int:
	get:
		return _get_calculated_stat("calc_def")
	set(value):
		push_error("can't set calculated stats")
		
var stat_mag: int:
	set(value):
		stat_mag = value
		_set("stat_mag", value)
		
var calc_mag: int:
	get:
		return _get_calculated_stat("calc_mag")
	set(value):
		push_error("can't set calculated stats")
		
var stat_res: int:
	set(value):
		stat_res = value
		_set("stat_res", value)
		
var calc_res: int:
	get:
		return _get_calculated_stat("calc_res")
	set(value):
		push_error("can't set calculated stats")
		
var stat_dex: int:
	set(value):
		stat_dex = value
		_set("stat_dex", value)
		
var calc_dex: int:
	get:
		return _get_calculated_stat("calc_dex")
	set(value):
		push_error("can't set calculated stats")
		
var stat_luk: int:
	set(value):
		stat_luk = value
		_set("stat_luk", value)
		
var calc_luk: int:
	get:
		return _get_calculated_stat("calc_luk")
	set(value):
		push_error("can't set calculated stats")
		
var stat_cha: int:
	set(value):
		stat_cha = value
		_set("stat_cha", value)
		
var calc_cha: int:
	get:
		return _get_calculated_stat("calc_cha")
	set(value):
		push_error("can't set calculated stats")

signal died

func _init() -> void:
	watchable_props.append_array(["unit_name", "level", "stat_hp", "calc_hp", "current_hp", "stat_mp",\
			"calc_mp", "current_mp", "stat_atk", "calc_atk", "stat_def", "calc_def", "stat_mag",\
			"calc_mag", "stat_res", "calc_res", "stat_dex", "calc_dex", "stat_luk", "calc_luk",\
			"stat_cha", "calc_cha"])
	#super()

func _get_calculated_stat(stat: String) -> int:
	var base = "stat" + stat.right(-4)
	var calc = get(base)
	if get("armor"):
		calc += self.armor.get(base)
	if get("weapon"):
		calc += self.weapon.get(base)
	for buff in buffs:
		calc += buff.get(base)
	return calc

func combat_action():
	pass

func heal_damage(dmg: int):
	current_hp += dmg
	if current_hp > stat_hp:
		current_hp = stat_hp

func take_damage(dmg: int):
	current_hp -= dmg
	if current_hp <= 0:
		current_hp = 0
		if combat:
			combat.remove_unit(self)
		died.emit()
