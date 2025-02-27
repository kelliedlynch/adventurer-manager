extends CombatUnit
class_name Adventurer

var adventurer_class: AdventurerClass
		
var portrait: Texture2D = get_random_portrait()

var hire_cost: int = 0
		
var traits: Array[Trait] = []

var _experience: int = 0
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

var status: int = STATUS_IDLE:
	set(value):
		status = value
		property_changed.emit()



signal property_changed

var weapon: Weapon
var armor: Armor

func _init() -> void:
	#super()
	adventurer_class = AdventurerClass.random()
	unit_name = NameGenerator.new_name()
	for stat in adventurer_class.stat_weight_overrides:
		stat_weights[stat] = adventurer_class.stat_weight_overrides[stat]
	_assign_level_up_points()
	if !Engine.is_editor_hint():
		Game.game_tick_advanced.connect(_on_game_tick_advanced)


func _on_game_tick_advanced():
	if status & STATUS_IDLE and status & ~STATUS_DEAD and current_mp < stat_mp:
		current_mp += 1

func equip(item: Equipment):
	if item is Weapon:
		weapon = item
	elif item is Armor:
		armor = item
	if item.stat_hp != 0:
		current_hp = clamp(current_hp + item.stat_hp, 1, stat_hp)
	if item.stat_mp != 0:
		current_mp = clamp(current_mp + item.stat_mp, 1, stat_mp)
	item.status = Equipment.ITEM_EQUIPPED

func unequip(item: Equipment):
	if item == weapon:
		weapon = null
	elif item == armor:
		armor = null
	if item.stat_hp != 0:
		current_hp = clamp(current_hp - item.stat_hp, 1, stat_hp)
	if item.stat_mp != 0:
		current_mp = clamp(current_mp - item.stat_mp, 1, stat_mp)
	item.status = Equipment.ITEM_NOT_EQUIPPED
	
func unequip_all():
	if weapon:
		unequip(weapon)
	if armor:
		unequip(armor)

func level_up():
	super()
	hire_cost += 3
	if not Engine.is_editor_hint() and Game.player and Game.player.roster.has(self):
		var msg = ActivityLogMessage.new()
		msg.menu = RosterInterface.instantiate
		msg.text = "%s is now level %d" % [unit_name, level]
		Game.activity_log.push_message(msg)
	
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

func take_damage(dmg: int, dmg_type: DamageType = DamageType.TRUE):
	if status & STATUS_DEAD: return
	super(dmg, dmg_type)
	if current_hp == 0:
		status |= STATUS_DEAD

func heal_damage(dmg: int = stat_hp):
	#if current_hp <= 0 and dmg > 0 and dmg > 0 - current_hp:
		#status &= ~STATUS_DEAD
	super(dmg)
	if status & STATUS_DEAD and current_hp > 0:
		status &= ~STATUS_DEAD
		
static func generate_random_newbie() -> Adventurer:
	if not rng:
		rng = RandomNumberGenerator.new()
	var noob = Adventurer.new()
	for i in randi_range(1, 3):
		var t = Trait.TraitList.pick_random()
		if noob.traits.has(t): 
			continue
		noob.traits.append(t)
	noob.level_up()
	if randi() % 2 == 0:
		var equipment = Equipment.generate_random_equipment()
		Game.player.inventory.append(equipment)
		noob.equip(equipment)
	#rng = RandomNumberGenerator.new()
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
	STATUS_DEAD = 8
}
