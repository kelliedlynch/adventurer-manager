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
	stat_luk = 0,
	stat_cha = 0
}

var stat_hp: int
var current_hp: int

var stat_mp: int
var current_mp: int

var stat_atk: int
var stat_def: int
var stat_mag: int
var stat_res: int
var stat_dex: int
var stat_luk: int
var stat_cha: int

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
