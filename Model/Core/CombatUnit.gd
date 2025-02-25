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

func take_damage(dmg: int):
	current_hp -= dmg
	if current_hp <= 0:
		current_hp = 0
		if combat:
			combat.remove_unit(self)
		died.emit()
		var msg = ActivityLogMessage.new()
		msg.text = unit_name + " died."
		Game.activity_log.push_message(msg, self is Adventurer)
