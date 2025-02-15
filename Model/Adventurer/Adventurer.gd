extends CombatUnit
class_name Adventurer

static var rng: RandomNumberGenerator
		
var adventurer_class: AdventurerClass = AdventurerClass.random().new():
	set(value):
		adventurer_class = value
		_set("adventurer_class", value)
		
var portrait: Texture2D = get_random_portrait()

var hire_cost: int = 0
		
var traits: Array[Variant] = []

var _experience: int = 0:
	set(value):
		_experience = value
		_set("experience", value)
var experience: int:
	get:
		return _experience
	set(value):
		push_error("cannot set exp, use add_experience")
		
# TODO: figure out how I should actually handle modified stats, and how to make ReactiveFields remain
#		reactive when I do so.
var mod_stat_atk: int:
	get:
		var value = stat_atk
		if armor:
			value += armor.stat_atk
		if weapon:
			value += weapon.stat_atk
		return value
	set(value):
		push_error("cannot set modified stat")
		
var mod_stat_def: int:
	get:
		var value = stat_def
		if armor:
			value += armor.stat_def
		if weapon:
			value += weapon.stat_def
		return value
	set(value):
		push_error("cannot set modified stat")
		
var next_level_exp: int:
	get:
		var total = 0
		for i in range(1, level + 1):
			total += adventurer_class.xp_curve.sample(i)
		return total - experience
	set(value):
		push_error("cannot set next_level_exp")

var status: int = STATUS_IDLE

var weapon: Weapon:
	set(value):
		weapon = value
		value.status = Equipment.ITEM_EQUIPPED
		_set("weapon", value)
var armor: Armor:
	set(value):
		armor = value
		value.status = Equipment.ITEM_EQUIPPED
		_set("armor", value)

#signal equipment_changed

func _init() -> void:
	watchable_props.append_array(["experience", "weapon", "armor"])
	unit_name = NameGenerator.new_name()
	for stat in adventurer_class.stat_overrides:
		set(stat, adventurer_class.stat_overrides[stat])
		if stat == "stat_hp":
			set("current_hp", adventurer_class.stat_overrides[stat])
		if stat == "stat_mp":
			set("current_mp", adventurer_class.stat_overrides[stat])
	if !Engine.is_editor_hint():
		GameplayEngine.game_tick_advanced.connect(_on_game_tick_advanced)
	super()

func _on_game_tick_advanced():
	if status & STATUS_IDLE and status & ~STATUS_INCAPACITATED and current_mp < stat_mp:
		current_mp += 1

func level_up():
	level += 1
	var vals = adventurer_class.stat_level_up_values
	for stat in vals:
		if not rng:
			rng = RandomNumberGenerator.new()
		var weights = []
		var normalized = Utility.normalize_range(vals[stat].range)
		for i in normalized.size():
			var b = normalized[i]
			var a = vals[stat].curve.sample(b)
			weights.append(a)
		var index = rng.rand_weighted(weights)
		var add_val = vals[stat].range[index]
		if add_val > 0:
			set(stat, get(stat) + add_val)
			if stat == "stat_hp":
				set("current_hp", get("current_hp") + add_val)
			if stat == "stat_mp":
				set("current_mp", get("current_mp") + add_val)
	hire_cost += 3
	if not Engine.is_editor_hint() and Player and Player.roster.has(self):
		var msg = ActivityLogMessage.new()
		msg.menu = RosterInterface.instantiate
		msg.text = "%s is now level %d" % [unit_name, level]
		GameplayEngine.activity_log.push_message(msg)
	
func add_experience(add_xp: int):
	var remaining = add_xp
	while remaining > 0:
		if remaining >= next_level_exp:
			level_up()
			remaining -= next_level_exp
		else:
			remaining = 0
	_experience += add_xp
		
func combat_action():
	adventurer_class.combat_action(self, combat)

func take_damage(dmg: int):
	super(dmg)
	if current_hp == 0:
		status |= STATUS_INCAPACITATED
		
static func generate_random_newbie() -> Adventurer:
	var noob = Adventurer.new()
	#if randi() % 2 == 0:
	noob.traits.append(Trait.ROBUST)
	noob.level_up()
	rng = RandomNumberGenerator.new()
	var base_xp = range(50)[rng.rand_weighted(range(50))]
	var add_xp = range(0, 300, 15)[rng.rand_weighted(range(21, 1, -1))]
	noob.add_experience(base_xp + add_xp)
	return noob

static func get_random_portrait():
	var portraits = ResourceLoader.list_directory("res://Graphics/Portraits")
	var filename = portraits[randi_range(0, portraits.size() - 1)]
	return load("res://Graphics/Portraits/" + filename)

enum {
	STATUS_IDLE = 1,
	STATUS_IN_BUILDING = 2,
	STATUS_IN_DUNGEON = 4,
	STATUS_INCAPACITATED = 8
}
