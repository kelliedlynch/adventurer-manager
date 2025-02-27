extends WithStats
class_name Equipment

var item_name: String = "Generic Equipment"
		
var texture: Texture2D = load("res://Graphics/Equipment/Weapons/sv_t_01.png")

var rarity: Rarity = Rarity.COMMON
var status: int = ITEM_NOT_EQUIPPED

var stat_weights: Dictionary[String, float] = {
	stat_hp = 1,
	stat_mp = 1,
	stat_atk = 1,
	stat_def = 1,
	stat_mag = 1,
	stat_res = 1,
	stat_dex = 1,
	stat_luk = .1,
	stat_cha = 1
}

var stat_focus_type: FocusType

func _init(rare: Rarity = Rarity.COMMON) -> void:
	rarity = rare
	assign_stat_mods()
	texture = get_random_texture(self)

func assign_stat_mods() -> void:
	var number_of_mods: int = 1
	match rarity:
		Rarity.COMMON:
			if randi() % 3 == 0:
				number_of_mods += 1
		Rarity.UNCOMMON:
			number_of_mods += 1
			number_of_mods += rng.rand_weighted([1, 3, 1])
		Rarity.RARE:
			number_of_mods += 3
			number_of_mods += rng.rand_weighted([.5, 3, 1, .4])
		Rarity.EPIC:
			number_of_mods += 5
			number_of_mods += rng.rand_weighted([.3, 3, 2, 1, .4])
	
	var new_weights = stat_weights.duplicate()
	for i in number_of_mods:
		var index = rng.rand_weighted(new_weights.values())
		var key = new_weights.keys()[index]
		new_weights[key] += 2
		base_stats[key] += 1

static func generate_random_equipment(rarity: Rarity = Rarity.COMMON, item_type = null) -> Equipment:
	var equip_type = [Weapon, Armor].pick_random() if not item_type else item_type
	return equip_type.new(rarity)
	
static func get_random_texture(for_obj: Equipment):
	var dir = "Weapons" if for_obj is Weapon else "Armor"
	var portraits = ResourceLoader.list_directory("res://Graphics/Equipment/" + dir)
	var filename = portraits[randi_range(0, portraits.size() - 1)]
	return load("res://Graphics/Equipment/" + dir + "/" + filename)

enum {
	ITEM_NOT_EQUIPPED = 1,
	ITEM_EQUIPPED = 2
}

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC
}

enum FocusType {
	PHYSICAL,
	MAGIC,
	SOCIAL
}
