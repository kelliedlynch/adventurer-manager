extends Resource
class_name Equipment

var item_name: String = "Generic Equipment"
		
var texture: Texture2D = load("res://Graphics/Equipment/Weapons/sv_t_01.png")

var stat_mods: Dictionary[String, int] = {}

var status: int = ITEM_NOT_EQUIPPED

static func generate_random_equipment() -> Equipment:
	var equip_type = [Weapon, Armor].pick_random()
	return equip_type.new()

enum {
	ITEM_NOT_EQUIPPED = 1,
	ITEM_EQUIPPED = 2
}
