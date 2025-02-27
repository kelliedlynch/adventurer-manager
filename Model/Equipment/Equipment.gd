extends WithStats
class_name Equipment

var item_name: String = "Generic Equipment"
		
var texture: Texture2D = load("res://Graphics/Equipment/Weapons/sv_t_01.png")

var rarity: Rarity = Rarity.COMMON
var status: int = ITEM_NOT_EQUIPPED

var stat_focus_type: FocusType

func _init(rare: Rarity = Rarity.COMMON) -> void:
	rarity = rare
	assign_stat_mods()
	texture = get_random_texture(self)

func assign_stat_mods() -> void:
	pass

static func generate_random_equipment(rare: Rarity = Rarity.COMMON, item_type = null) -> Equipment:
	var equip_type = [Weapon, Armor].pick_random() if not item_type else item_type
	return equip_type.new(rare)
	
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
