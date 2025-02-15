extends Watchable
class_name Equipment

var item_name: String = "Generic Equipment":
	set(value):
		item_name = value
		_set("item_name", value)
		
var texture: Texture2D = load("res://Graphics/Equipment/Weapons/sv_t_01.png"):
	set(value):
		texture = value
		_set("texture", value)

var stat_hp: int = 0:
	set(value):
		stat_hp = value
		_set("stat_hp", value)

var stat_mp: int = 0:
	set(value):
		stat_mp = value
		_set("stat_mp", value)

var stat_atk: int = 0:
	set(value):
		stat_atk = value
		_set("stat_atk", value)
		
var stat_def: int = 0: 
	set(value):
		stat_def = value
		_set("stat_def", value)
		
var stat_mag: int = 0:
	set(value):
		stat_mag = value
		_set("stat_mag", value)
		
var stat_res: int = 0:
	set(value):
		stat_res = value
		_set("stat_res", value)
		
var stat_dex: int = 0:
	set(value):
		stat_dex = value
		_set("stat_dex", value)
		
var stat_luk: int = 0:
	set(value):
		stat_luk = value
		_set("stat_luk", value)
		
var stat_cha: int = 0:
	set(value):
		stat_cha = value
		_set("stat_cha", value)

var status: int = ITEM_NOT_EQUIPPED

func _init() -> void:
	watchable_props.append_array(["item_name", "stat_hp", "stat_mp", "stat_atk", "stat_def", \
			"stat_mag", "stat_res", "stat_dex", "stat_luk", "stat_cha"])

enum {
	ITEM_NOT_EQUIPPED = 1,
	ITEM_EQUIPPED = 2
}
