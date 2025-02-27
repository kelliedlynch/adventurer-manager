extends Equipment
class_name Weapon

func _init(rare: Rarity = Rarity.COMMON) -> void:
	item_name = "Weapon"
	super(rare)
	
	

		
	

func assign_stat_mods() -> void:
	
	match stat_focus_type:
		FocusType.PHYSICAL:
			stat_weights.stat_hp += 1
			stat_weights.stat_atk += 3
			stat_weights.stat_dex += 1
		FocusType.MAGIC:
			stat_weights.stat_mp += 1
			stat_weights.stat_mag += 3
			stat_weights.stat_mp += 1
	super()
