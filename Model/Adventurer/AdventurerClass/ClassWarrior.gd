extends AdventurerClass
class_name ClassWarrior

func _init():
	adventurer_class_name = "Warrior"
	stat_weight_overrides = {
		stat_hp = 4,
		stat_atk = 2,
		stat_def = 2,
		stat_mag = .5,
		stat_res = .8,
		stat_dex = 1.5
	}
	#level_up_stat_bonuses = {
		#stat_hp = 2,
		#stat_atk = 1,
		#stat_def = 1,
		#stat_cha = 1,
	#}
	super()

func combat_action(unit: Adventurer, combat: Combat):
	super(unit, combat)
