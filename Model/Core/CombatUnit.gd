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

var current_hp: int
var current_mp: int

signal died

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

func heal_damage(dmg: int = stat_hp):
	current_hp += dmg
	if current_hp > stat_hp:
		current_hp = stat_hp

func take_damage(dmg: int, dmg_type = DamageType.TRUE):
	var resistances = []
	if dmg_type & DamageType.PHYSICAL:
		resistances.append(stat_def)
	if dmg_type & DamageType.MAGIC:
		resistances.append(stat_res)
	var mitigated = resistances.reduce(func(accum, val): return val + accum, 0) / resistances.size() if not resistances.is_empty() else 0
	var total_dmg = max(0, dmg - int(mitigated))
	current_hp -= total_dmg
	var msg = ActivityLogMessage.new("%s took %d %s damage" % [unit_name, total_dmg, DamageType.find_key(dmg_type).capitalize()])
	if mitigated > 0:
		msg.text += " (%d mitigated)" % mitigated
	Game.activity_log.push_message(msg, false)
	if current_hp <= 0:
		die()

func die():
	current_hp = 0
	if combat:
		combat.remove_unit(self)
	var msg = ActivityLogMessage.new(unit_name + " died.")
	Game.activity_log.push_message(msg, self is Adventurer)

enum DamageType {
	TRUE = 0,
	PHYSICAL = 1,
	MAGIC = 2,
	FIRE = 4,
	ICE = 8
}
