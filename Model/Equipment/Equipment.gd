extends Resource
class_name Equipment

var item_name: String = "Generic Equipment":
	set(value):
		item_name = value
		property_changed.emit("item_name")
		
var texture: Texture2D = load("res://Graphics/Equipment/Weapons/sv_t_01.png"):
	set(value):
		texture = value
		property_changed.emit("texture")

var stat_hp: int = 0:
	set(value):
		stat_hp = value
		property_changed.emit("stat_hp")

var stat_mp: int = 0:
	set(value):
		stat_mp = value
		property_changed.emit("stat_mp")

var stat_atk: int = 0:
	set(value):
		stat_atk = value
		property_changed.emit("stat_atk")
		
var stat_def: int = 0: 
	set(value):
		stat_def = value
		property_changed.emit("stat_def")
		
var stat_mag: int = 0:
	set(value):
		stat_mag = value
		property_changed.emit("stat_mag")
		
var stat_res: int = 0:
	set(value):
		stat_res = value
		property_changed.emit("stat_res")
		
var stat_dex: int = 0:
	set(value):
		stat_dex = value
		property_changed.emit("stat_dex")
		
var stat_luk: int = 0:
	set(value):
		stat_luk = value
		property_changed.emit("stat_luk")
		
var stat_cha: int = 0:
	set(value):
		stat_cha = value
		property_changed.emit("stat_cha")

		
signal property_changed
