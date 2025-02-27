extends AdventurerClass
class_name ClassWarrior

func _init():
	adventurer_class_name = "Warrior"
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

func combat_action(unit: Adventurer, combat: Combat):
	super(unit, combat)
