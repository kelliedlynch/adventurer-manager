extends Adventurer
class_name Rogue

func _init() -> void:
	adventurer_class = "Rogue"
	damage_type = CombatUnit.DamageType.PHYSICAL
	base_stats = {
		stat_hp = 10,
		stat_atk = 10,
		stat_def = 1,
		stat_cha = 1,
		stat_brv = 1
	}
	level_up_stats = {
		stat_hp = 2.1,
		stat_atk = 1.2,
		stat_def = .5,
		stat_cha = 0,
		stat_brv = 0,
	}
	super()
