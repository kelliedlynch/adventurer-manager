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

var status: int = 0:
	set(value):
		status = value
		property_changed.emit()

signal property_changed



func _init() -> void:
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

## Override in subclass if unit should do something besides perform basic attack on random opponent
func combat_action(combat: Combat):
	var enemies = combat.alive_enemies
	if enemies.is_empty(): return
	var party = combat.alive_party
	if party.is_empty(): return
	var targets = party if self is Enemy else enemies
	var target = targets.pick_random()
	push_attack_msg(target, stat_atk)
	target.take_damage(stat_atk, damage_type)
	
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
	var new_hp = clamp(current_hp + dmg, 0, stat_hp)
	if status & STATUS_DEAD and new_hp > 0:
		status &= ~STATUS_DEAD
	push_heal_msg(new_hp - current_hp)
	current_hp = new_hp
	
func push_heal_msg(dmg: int):
	var msg = "%s healed %d damage." % [unit_name, dmg]
	Game.activity_log.push_message(ActivityLogMessage.new(msg))

func take_damage(dmg: int, dmg_type = DamageType.TRUE):
	if dmg == 0 or status & STATUS_DEAD: return
	var mitigated = stat_def if dmg_type & DamageType.PHYSICAL else 0
	var total_dmg = max(0, dmg - int(mitigated))
	current_hp -= total_dmg
	push_damage_msg(total_dmg, dmg_type, mitigated)
	if current_hp <= 0:
		die()

func die():
	current_hp = 0
	status |= STATUS_DEAD
	var msg = ActivityLogMessage.new(unit_name + " died.")
	Game.activity_log.push_message(msg, self is Adventurer)
	died.emit()
	
func push_damage_msg(dmg, dmg_type, mitigated):
	var msg = ActivityLogMessage.new("%s took %d %s damage" % [unit_name, dmg, DamageType.find_key(dmg_type).capitalize()])
	if mitigated > 0:
		msg.text += " (%d mitigated)" % mitigated
	Game.activity_log.push_message(msg, false)

func push_attack_msg(target: CombatUnit, dmg: int):
	var msg = ActivityLogMessage.new("%s attacked %s for %d damage" % [unit_name, target.unit_name, dmg])
	Game.activity_log.push_message(msg, false)

	



enum {
	STATUS_DEAD = 8,
}
