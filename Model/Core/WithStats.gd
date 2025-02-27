extends Resource
## Base class for anything with stats, like Adventurers, Enemies, Equipment, or Buffs
class_name WithStats

static var rng: RandomNumberGenerator:
	get: 
		if not rng: 
			rng = RandomNumberGenerator.new()
		return rng

## base_stats are floats for leveling up purposes, but in-game calculations only use them as ints
var base_stats: Dictionary[String, float] = {
	stat_hp = 0,
	stat_atk = 0,
	stat_def = 0,
	stat_cha = 0,
	stat_brv = 0
}

var stat_hp: int: 
	get: return _get("stat_hp")
	set(value): _set("stat_hp", value)
var stat_atk: int:
	get: return _get("stat_atk")
	set(value): _set("stat_atk", value)
var stat_def: int:
	get: return _get("stat_def")
	set(value): _set("stat_def", value)
var stat_cha: int:
	get: return _get("stat_cha")
	set(value): _set("stat_cha", value)
var stat_brv: int:
	get: return _get("stat_brv")
	set(value): _set("stat_brv", value)

func _get(property: StringName):
	if base_stats.has(property):
		return int(base_stats[property])

func _set(property: StringName, value: Variant) -> bool:
	if base_stats.has(property):
		base_stats[property] = value
		return true
	#elif property == "current_hp" or property == "current_mp":
		#pass
	return false
