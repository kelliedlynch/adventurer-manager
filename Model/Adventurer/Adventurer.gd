extends CombatUnit
class_name Adventurer

var adventurer_class: String
var xp_curve: Curve = load("res://Model/Adventurer/BaseLevelUpCurve.tres")
var portrait: Texture2D

var hire_cost: int = 10

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
			total += xp_curve.sample(i)
		return total - experience
	set(value):
		push_error("cannot set next_level_exp")

var weapon: Weapon
var armor: Armor

func _init() -> void:
	unit_name = NameGenerator.new_name()
	status |= STATUS_IDLE
	super()

func equip(item: Equipment):
	if item is Weapon:
		weapon = item
	elif item is Armor:
		armor = item
	if item.stat_hp != 0:
		current_hp = clamp(current_hp + item.stat_hp, 1, stat_hp)
	item.status = Equipment.ITEM_EQUIPPED

func unequip(item: Equipment):
	if item == weapon:
		weapon = null
	elif item == armor:
		armor = null
	if item.stat_hp != 0:
		current_hp = clamp(current_hp - item.stat_hp, 1, stat_hp)
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
	
## Called after all units enter combat, and before rounds start
func _hook_on_begin_combat(_dungeon: Dungeon):
	pass
	
## Called after combat result has been determined, and after xp rewards are assigned (if applicable)
func _hook_on_end_combat(_dungeon: Dungeon):
	pass

enum {
	STATUS_IDLE = 1,
	STATUS_IN_BUILDING = 2,
	STATUS_IN_DUNGEON = 4,
}
