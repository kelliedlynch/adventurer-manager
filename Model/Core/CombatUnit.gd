extends WithStats
## Base class for Adventurers or Enemies. Handles HP/MP, damage, healing, death, and combat actions.
## Also calculates stat current values including equipment and buffs.
class_name CombatUnit

var buffs = []

var unit_name: String = "":
	set(value):
		unit_name = value

var level: int = 1
var current_hp: int

var level_up_stats: Dictionary[String, float] = {
	stat_hp = 0,
	stat_atk = 0,
	stat_def = 0,
	stat_cha = 0,
	stat_brv = 0,
}
signal died

var damage_type: DamageType

func _init() -> void:
	pass
	#base_stats.stat_hp = 5
	current_hp = stat_hp

func _get(property: StringName):
	if base_stats.has(property):
		var calc = base_stats[property]
		if "weapon" in self and self.weapon:
			calc += self.weapon.get(property)
		if "armor" in self and self.armor:
			calc += self.armor.get(property)
		for buff in buffs:
			calc += buff.get(property)
		return calc if calc > 0 else 0

func combat_action(combat: Combat):
	pass
	
func _assign_level_up_points():
	for stat in level_up_stats:
		var before_levelup = _get(stat)
		base_stats[stat] += level_up_stats[stat]
		if stat == "stat_hp":
			current_hp += stat_hp - before_levelup

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
	var mitigated = stat_def if dmg_type & DamageType.PHYSICAL else 0
	var total_dmg = max(0, dmg - int(mitigated))
	current_hp -= total_dmg
	push_damage_msg(total_dmg, dmg_type, mitigated)
	if current_hp <= 0:
		die()

func die():
	current_hp = 0
	
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
