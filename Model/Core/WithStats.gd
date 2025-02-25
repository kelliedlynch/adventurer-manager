extends Resource
## Base class for anything with stats, like Adventurers, Enemies, Equipment, or Buffs
class_name WithStats

static var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var base_stats: Dictionary = {
	stat_hp = 0,
	stat_mp = 0,
	stat_atk = 0,
	stat_def = 0,
	stat_mag = 0,
	stat_res = 0,
	stat_dex = 0,
	stat_luk = 0,
	stat_cha = 0
}

var stat_hp: int: 
	get: return _get("stat_hp")
	set(value): _set("stat_hp", value)

var stat_mp: int:
	get: return _get("stat_mp")
	set(value): _set("stat_mp", value)

var stat_atk: int:
	get: return _get("stat_atk")
	set(value): _set("stat_atk", value)
var stat_def: int:
	get: return _get("stat_def")
	set(value): _set("stat_def", value)
var stat_mag: int:
	get: return _get("stat_mag")
	set(value): _set("stat_mag", value)
var stat_res: int:
	get: return _get("stat_res")
	set(value): _set("stat_res", value)
var stat_dex: int:
	get: return _get("stat_dex")
	set(value): _set("stat_dex", value)
var stat_luk: int:
	get: return _get("stat_luk")
	set(value): _set("stat_luk", value)
var stat_cha: int:
	get: return _get("stat_cha")
	set(value): _set("stat_cha", value)

func _init() -> void:
	if not rng:
		rng = RandomNumberGenerator.new()

func _get(property: StringName):
	if base_stats.has(property):
		return base_stats[property]

func _set(property: StringName, value: Variant) -> bool:
	if base_stats.has(property):
		base_stats[property] = value
		return true
	return false
