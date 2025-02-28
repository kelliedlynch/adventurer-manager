extends AdventurerClass
class_name ClassHealer

var heal_mp_cost: int = 3
var max_revive_charges: int = 1
var revive_charges: int

func _init():
	adventurer_class_name = "Healer"
	damage_type = CombatUnit.DamageType.MAGIC
	base_stats = {
		stat_hp = 12,
		stat_atk = 6,
		stat_def = 2,
		stat_cha = 1,
		stat_brv = 1
	}
	level_up_stats = {
		stat_hp = 3,
		stat_atk = .8,
		stat_def = 1.2,
		stat_cha = 0,
		stat_brv = 0,
	}
	super()


func _on_hook_adventurer_died(healer: Adventurer, target: Adventurer):
	if revive_charges > 0 and target.current_hp <= 0:
		target.heal_damage()
		var msg = "%s revived %s with a spell." % [healer.unit_name, target.unit_name]
		revive_charges -= 1

func _on_hook_begin_combat():
	revive_charges = max_revive_charges
