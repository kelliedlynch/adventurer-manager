extends WithStats
## Base class for Adventurers or Enemies. Handles HP/MP, damage, healing, death, and combat actions.
## Also calculates stat current values including equipment and buffs.
class_name CombatUnit

var combat: Combat

var buffs = []

var unit_name: String = "":
	set(value):
		unit_name = value

var level: int = 0:
	set(value):
		level = value
var current_hp: int = base_stats.stat_hp
var current_mp: int = base_stats.stat_mp

var stat_level_up_points: int = 7
var stat_weights: Dictionary[String, float] = {
	stat_hp = 3,
	stat_mp = 1,
	stat_atk = 1,
	stat_def = 1,
	stat_mag = 1,
	stat_res = 1,
	stat_dex = 1,
	stat_luk = .1,
	stat_cha = 1
}
var base_level_up_stats: Dictionary[String, int] = {
	stat_hp = 1,
	stat_mp = 1,
	stat_atk = 1,
	stat_def = 1,
	stat_mag = 1,
	stat_res = 1,
	stat_dex = 1,
	stat_luk = 0,
	stat_cha = 1
}
#signal died

func _init() -> void:
	base_stats.stat_hp = 5
	current_hp = base_stats.stat_hp

func _get(property: StringName):
	if base_stats.has(property):
		var calc = base_stats[property]
		if "weapon" in self and self.weapon:
			calc += self.weapon.get(property)
		if "armor" in self and self.armor:
			calc += self.armor.get(property)
		for buff in buffs:
			calc += buff.get(property)
		return calc

func combat_action():
	pass
	
func _assign_level_up_points():
	for stat in base_level_up_stats:
		base_stats[stat] += base_level_up_stats[stat]
		if stat == "stat_hp":
			current_hp += base_level_up_stats[stat]
		elif stat == "stat_mp":
			current_mp += base_level_up_stats[stat]
	var weights = stat_weights.values()
	for i in stat_level_up_points:
		var index = rng.rand_weighted(weights)
		var stat_name = stat_weights.keys()[index]
		set(stat_name, base_stats[stat_name] + 1)
		if stat_name == "stat_hp":
			current_hp += 1
		elif stat_name == "stat_mp":
			current_mp += 1

func level_up():
	level += 1
	_assign_level_up_points()

func heal_damage(dmg: int = stat_hp):
	var new_hp = current_hp + dmg
	var overheal = max(new_hp - stat_hp, 0)
	push_heal_msg(dmg, overheal)
	current_hp = min(new_hp, stat_hp)
	
func push_heal_msg(dmg: int, overheal: int = 0):
	var msg = "%s healed %d damage." % [unit_name, dmg]
	if overheal > 0:
		msg += " (%d overheal)" % overheal
	Game.activity_log.push_message(ActivityLogMessage.new(msg))

func take_damage(dmg: int, dmg_type = DamageType.TRUE):
	if dmg == 0 or current_hp <= 0: return
	var resistances = []
	if dmg_type & DamageType.PHYSICAL:
		resistances.append(stat_def)
	if dmg_type & DamageType.MAGIC:
		resistances.append(stat_res)
	var mitigated = resistances.reduce(func(accum, val): return val + accum, 0) / resistances.size() if not resistances.is_empty() else 0
	mitigated = min(mitigated, dmg)
	var total_dmg = max(0, dmg - int(mitigated))
	current_hp -= total_dmg
	push_damage_msg(total_dmg, dmg_type, mitigated)
	if current_hp <= 0:
		die()

func die():
	current_hp = 0
	# TODO: I'm not happy with having combat stored on this object. See if it can be event-based again.
	if combat:
		combat.remove_unit(self)
	var msg = ActivityLogMessage.new(unit_name + " died.")
	Game.activity_log.push_message(msg, self is Adventurer)
	
func push_damage_msg(dmg, dmg_type, mitigated):
	var msg = ActivityLogMessage.new("%s took %d %s damage" % [unit_name, dmg, DamageType.find_key(dmg_type).capitalize()])
	if mitigated > 0:
		msg.text += " (%d mitigated)" % mitigated
	Game.activity_log.push_message(msg, false)

func push_attack_msg(target: CombatUnit, dmg: int):
	var msg = ActivityLogMessage.new("%s attacked %s for %d damage" % [unit_name, target.unit_name, dmg])
	Game.activity_log.push_message(msg, false)

enum DamageType {
	TRUE = 0,
	PHYSICAL = 1,
	MAGIC = 2,
	FIRE = 4,
	ICE = 8
}
