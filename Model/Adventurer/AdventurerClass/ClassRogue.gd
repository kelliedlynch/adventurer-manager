extends AdventurerClass
class_name ClassRogue

func _init() -> void:
	adventurer_class_name = "Rogue"
	stat_weight_overrides = {
		stat_mp = 1.2,
		stat_atk = 2,
		stat_def = .6,
		stat_res = 1.4,
		stat_dex = 2,
		stat_luk = .2,
		stat_cha = 1.5
	}
	super()
