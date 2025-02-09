extends Resource
class_name Adventurer

var name: String = "Adventurer":
	set(value):
		name = value
		property_changed.emit("name")
		
var adventurer_class: AdventurerClass = AdventurerClass.random().new():
	set(value):
		adventurer_class = value
		property_changed.emit("adventurer_class")
		
var portrait: Texture2D = get_random_portrait():
	set(value):
		portrait = value
		property_changed.emit("portrait")
		
var level: int = 0:
	set(value):
		level = value
		property_changed.emit("level")
		
var stat_hp: int = 70:
	set(value):
		stat_hp = value
		property_changed.emit("stat_hp")
		
var stat_mp: int = 10:
	set(value):
		stat_mp = value
		property_changed.emit("stat_mp")
		
var stat_atk: int = 5:
	set(value):
		stat_atk = value
		property_changed.emit("stat_atk")
		
var stat_def: int = 3:
	set(value):
		stat_def = value
		property_changed.emit("stat_def")
		
var stat_mag: int = 1:
	set(value):
		stat_mag = value
		property_changed.emit("stat_mag")
		
var stat_res: int = 1:
	set(value):
		stat_res = value
		property_changed.emit("stat_res")
		
var stat_dex: int = 2:
	set(value):
		stat_dex = value
		property_changed.emit("stat_dex")
		
var stat_luk: int = 0:
	set(value):
		stat_luk = value
		property_changed.emit("stat_luk")
		
var stat_cha: int = 2:
	set(value):
		stat_cha = value
		property_changed.emit("stat_cha")
		
var hire_cost: int = 0:
	set(value):
		hire_cost = value
		property_changed.emit("hire_cost")
		
var current_hp: int = stat_hp:
	set(value):
		current_hp = value
		property_changed.emit("current_hp")
		
var current_mp: int = stat_mp:
	set(value):
		current_mp = value
		property_changed.emit("current_mp")

var _experience: int = 0:
	set(value):
		_experience = value
		property_changed.emit("experience")
var experience: int:
	get:
		return _experience
	set(value):
		push_error("cannot set exp, use add_experience")
		
var next_level_exp: int:
	get:
		var total = 0
		for i in range(1, level + 1):
			total += adventurer_class.xp_curve.sample(i)
		return total - experience
	set(value):
		push_error("cannot set next_level_exp")

signal property_changed

var status: int = STATUS_IDLE

func _init() -> void:
	for stat in adventurer_class.stat_overrides:
		set(stat, adventurer_class.stat_overrides[stat])
		if stat == "stat_hp":
			set("current_hp", adventurer_class.stat_overrides[stat])
		if stat == "stat_mp":
			set("current_mp", adventurer_class.stat_overrides[stat])

func level_up():
	level += 1
	var rng = RandomNumberGenerator.new()
	var vals = adventurer_class.stat_level_up_values
	for stat in vals:
		var add_val = vals[stat].range[rng.rand_weighted(vals[stat].weights)]
		if add_val > 0:
			set(stat, get(stat) + add_val)
			if stat == "stat_hp":
				set("current_hp", get("current_hp") + add_val)
			if stat == "stat_mp":
				set("current_mp", get("current_mp") + add_val)
	hire_cost += 3
	if Player and Player.roster.has(self):
		var msg = ActivityLogMessage.new()
		msg.menu = RosterInterface.instantiate
		msg.text = "%s is now level %d" % [name, level]
		GameplayEngine.activity_log.push_message(msg)
	
func add_experience(exp: int):
	var remaining = exp
	while remaining > 0:
		if remaining >= next_level_exp:
			level_up()
			remaining -= next_level_exp
		else:
			remaining = 0
	_experience += exp


static func generate_random_newbie() -> Adventurer:
	var noob = Adventurer.new()
	noob.level_up()
	noob.add_experience(randi_range(0, 180))
	return noob

static func get_random_portrait():
	var portraits = ResourceLoader.list_directory("res://Graphics/Portraits")
	var filename = portraits[randi_range(0, portraits.size() - 1)]
	return load("res://Graphics/Portraits/" + filename)

enum {
	STATUS_IDLE,
	STATUS_EXPLORING_DUNGEON
}
