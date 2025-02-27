extends Equipment
class_name Armor

func _init() -> void:
	#super()
	item_name = "Armor"
	var number_of_mods = rng.rand_weighted([3, 1, .5, .2, .04, .01]) + 1
	var stats_list = base_stats.keys()
	stats_list.erase(&"stat_hp")
	stats_list.erase(&"stat_mp")
	for i in number_of_mods:
		var stat = stats_list.pick_random()
		stats_list.erase(stat)
		var mod_value = rng.rand_weighted([2, 1, .5, .1, .01]) + 1
		set(stat, mod_value)
	texture = get_random_texture()


static func get_random_texture():
	var portraits = ResourceLoader.list_directory("res://Graphics/Equipment/Armor")
	var filename = portraits[randi_range(0, portraits.size() - 1)]
	return load("res://Graphics/Equipment/Armor/" + filename)
