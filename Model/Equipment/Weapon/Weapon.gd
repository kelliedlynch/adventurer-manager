extends Equipment
class_name Weapon

func _init() -> void:
	item_name = "Weapon"
	stat_mods.stat_atk = 2
	texture = load("res://Graphics/Equipment/Weapons/sv_t_10.png")
