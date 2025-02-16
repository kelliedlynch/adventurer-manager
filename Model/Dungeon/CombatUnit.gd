extends Watchable
class_name CombatUnit

var combat: Combat

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

var current_hp: int:
	set(value):
		current_hp = value
		_set("current_hp", value)

var stat_mp: int:
	set(value):
		stat_mp = value
		_set("stat_mp", value)

var current_mp: int :
	set(value):
		current_mp = value
		_set("current_mp", value)
		
var stat_atk: int:
	set(value):
		stat_atk = value
		_set("stat_atk", value)
		
var stat_def: int:
	set(value):
		stat_def = value
		_set("stat_def", value)
		
var stat_mag: int:
	set(value):
		stat_mag = value
		_set("stat_mag", value)
		
var stat_res: int:
	set(value):
		stat_res = value
		_set("stat_res", value)
		
var stat_dex: int:
	set(value):
		stat_dex = value
		_set("stat_dex", value)
		
var stat_luk: int:
	set(value):
		stat_luk = value
		_set("stat_luk", value)
		
var stat_cha: int:
	set(value):
		stat_cha = value
		_set("stat_cha", value)

signal died

func _init() -> void:
	watchable_props.append_array(["unit_name", "level", "stat_hp", "current_hp", "stat_mp", "current_mp",\
			 "stat_atk", "stat_def", "stat_mag", "stat_res", "stat_dex", "stat_luk", "stat_cha"])
	#super()

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
