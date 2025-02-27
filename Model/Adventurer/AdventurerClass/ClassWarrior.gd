extends AdventurerClass
class_name ClassWarrior

func _init():
	adventurer_class_name = "Warrior"
	stat_weight_overrides = {
		stat_hp = 6,
		stat_atk = 3,
		stat_def = 2,
		stat_mag = .5,
		stat_res = .8,
	}
	super()

func combat_action(unit: Adventurer, combat: Combat):
	super(unit, combat)
