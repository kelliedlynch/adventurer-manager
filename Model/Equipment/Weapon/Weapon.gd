extends Equipment
class_name Weapon

func _init(rare: Rarity = Rarity.COMMON, dmg_type = null) -> void:
	if dmg_type == null:
		damage_type = CombatUnit.DamageType.PHYSICAL if randi() & 1 else CombatUnit.DamageType.MAGIC
	item_name = "Weapon"
	super(rare)

func assign_stat_mods() -> void:
	stat_atk = rarity + 1
	super()
