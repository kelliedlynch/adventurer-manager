extends Adventurer
class_name Warrior

func _init():
	adventurer_class = "Warrior"
	damage_type = CombatUnit.DamageType.PHYSICAL
	base_stats = {
		stat_hp = 14,
		stat_atk = 8,
		stat_def = 4,
		stat_cha = 1,
		stat_brv = 1
	}
	level_up_stats = {
		stat_hp = 4,
		stat_atk = 1,
		stat_def = 1.1,
		stat_cha = 0,
		stat_brv = 0,
	}
	super()
