extends Equipment
class_name Armor

func _init(rare: Rarity = Rarity.COMMON) -> void:
	#super()
	item_name = "Armor"
	super(rare)

func assign_stat_mods() -> void:
	match stat_focus_type:
		FocusType.PHYSICAL:
			stat_weights.stat_hp += 2
			stat_weights.stat_def += 3
			stat_weights.stat_dex += 1
			stat_weights.stat_res += 1
		FocusType.MAGIC:
			stat_weights.stat_mag += 1
			stat_weights.stat_mp += 2
			stat_weights.stat_res += 3
			stat_weights.stat_def += 1
	super()
