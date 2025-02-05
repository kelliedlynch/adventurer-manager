extends Resource
class_name Adventurer

var name: String = "Adventurer":
	set(value):
		name = value
		property_changed.emit("name")
		
var adventurer_class: AdventurerClass = AdventurerClass.new():
	set(value):
		adventurer_class = value
		property_changed.emit("adventurer_class")
		
var portrait: Texture2D = get_random_portrait():
	set(value):
		portrait = value
		property_changed.emit("portrait")
		
var level: int = 1 + randi_range(0, 12):
	set(value):
		level = value
		property_changed.emit("level")
		
var stat_hp: int = 100 + randi_range(0, 30):
	set(value):
		stat_hp = value
		property_changed.emit("stat_hp")
		
var stat_mp: int = 50 + randi_range(0, 100):
	set(value):
		stat_mp = value
		property_changed.emit("stat_mp")
		
var stat_atk: int = 10 + randi_range(0, 5):
	set(value):
		stat_atk = value
		property_changed.emit("stat_atk")
		
var stat_def: int = 5 + randi_range(0, 5):
	set(value):
		stat_def = value
		property_changed.emit("stat_def")
		
var stat_mag: int = 1 + randi_range(0, 5):
	set(value):
		stat_mag = value
		property_changed.emit("stat_mag")
		
var stat_res: int = 1 + randi_range(0, 5):
	set(value):
		stat_res = value
		property_changed.emit("stat_res")
		
var stat_dex: int = 2 + randi_range(0, 5):
	set(value):
		stat_dex = value
		property_changed.emit("stat_dex")
		
var stat_luk: int = 1 + randi_range(0, 5):
	set(value):
		stat_luk = value
		property_changed.emit("stat_luk")
		
var stat_cha: int = 2 + randi_range(0, 5):
	set(value):
		stat_cha = value
		property_changed.emit("stat_cha")

signal property_changed

static func get_random_portrait():
	var portraits = ResourceLoader.list_directory("res://Graphics/Portraits")
	var filename = portraits[randi_range(0, portraits.size() - 1)]
	return load("res://Graphics/Portraits/" + filename)
