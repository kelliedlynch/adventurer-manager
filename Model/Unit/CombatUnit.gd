extends Resource
class_name CombatUnit

var combat: Combat

var buffs = []

var unit_name: String = "":
	set(value):
		unit_name = value

var level: int = 0:
	set(value):
		level = value

var base_stats: Dictionary = {
	stat_hp = 0,
	stat_mp = 0,
	stat_atk = 0,
	stat_def = 0,
	stat_mag = 0,
	stat_res = 0,
	stat_dex = 0,
	stat_luk = 0,
	stat_cha = 0
}

var stat_hp: int: 
	get: return _get("stat_hp")
	set(value): _set("stat_hp", value)
var current_hp: int
	#get: return _get("current_hp")
	#set(value): _set("current_hp", value)
var stat_mp: int:
	get: return _get("stat_mp")
	set(value): _set("stat_mp", value)
var current_mp: int
	#get: return _get("current_mp")
	#set(value): _set("current_mp", value)

var stat_atk: int:
	get: return _get("stat_atk")
	set(value): _set("stat_atk", value)
var stat_def: int:
	get: return _get("stat_def")
	set(value): _set("stat_def", value)
var stat_mag: int:
	get: return _get("stat_mag")
	set(value): _set("stat_mag", value)
var stat_res: int:
	get: return _get("stat_res")
	set(value): _set("stat_res", value)
var stat_dex: int:
	get: return _get("stat_dex")
	set(value): _set("stat_dex", value)
var stat_luk: int:
	get: return _get("stat_luk")
	set(value): _set("stat_luk", value)
var stat_cha: int:
	get: return _get("stat_cha")
	set(value): _set("stat_cha", value)

signal died

func _get(property: StringName):
	if base_stats.has(property):
		var calc = base_stats[property]
		if self.weapon and self.weapon.stat_mods.has(property):
			calc += self.weapon.stat_mods[property]
		if self.armor and self.armor.stat_mods.has(property):
			calc += self.armor.stat_mods[property]
		for buff in buffs:
			if buff.stat_mods.has(property):
				calc += buff.stat_mods[property]
		return calc
		
func _set(property: StringName, value: Variant) -> bool:
	if base_stats.has(property):
		base_stats[property] = value
		return true
	return false

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
