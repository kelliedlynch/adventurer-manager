extends Adventurer
class_name Mage

func _init():
	adventurer_class = "Mage"
	damage_type = CombatUnit.DamageType.MAGIC
	base_stats = {
		stat_hp = 10,
		stat_atk = 9,
		stat_def = 1,
		stat_cha = 1,
		stat_brv = 1
	}
	level_up_stats = {
		stat_hp = 1.8,
		stat_atk = 1.2,
		stat_def = .4,
		stat_cha = 0,
		stat_brv = 0,
	}
	super()
