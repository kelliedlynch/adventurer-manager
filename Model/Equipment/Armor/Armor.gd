extends Equipment
class_name Armor

func _init(rare: Rarity = Rarity.COMMON) -> void:
	#super()
	item_name = "Armor"
	super(rare)

func assign_stat_mods() -> void:
	stat_def = rarity + 1
	super()
