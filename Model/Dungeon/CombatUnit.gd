extends Resource
class_name CombatUnit

var combat: Combat

var stat_hp: int:
	set(value):
		stat_hp = value
		property_changed.emit("stat_hp")

var current_hp: int:
	set(value):
		current_hp = value
		property_changed.emit("current_hp")

var stat_mp: int:
	set(value):
		stat_mp = value
		property_changed.emit("stat_mp")

var current_mp: int :
	set(value):
		current_mp = value
		property_changed.emit("current_mp")
		
var stat_atk: int:
	set(value):
		stat_atk = value
		property_changed.emit("stat_atk")
		
var stat_def: int:
	set(value):
		stat_def = value
		property_changed.emit("stat_def")
		
var stat_mag: int:
	set(value):
		stat_mag = value
		property_changed.emit("stat_mag")
		
var stat_res: int:
	set(value):
		stat_res = value
		property_changed.emit("stat_res")
		
var stat_dex: int:
	set(value):
		stat_dex = value
		property_changed.emit("stat_dex")
		
var stat_luk: int:
	set(value):
		stat_luk = value
		property_changed.emit("stat_luk")
		
var stat_cha: int:
	set(value):
		stat_cha = value
		property_changed.emit("stat_cha")

signal property_changed
signal died

func combat_action():
	pass

func take_damage(dmg: int):
	current_hp -= dmg
	if current_hp <= 0:
		current_hp = 0
		if combat:
			combat.remove_unit(self)
		died.emit()
