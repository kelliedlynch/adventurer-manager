extends Resource
class_name Adventurer

var id: int = 0
var name: String = "Name"
var adventurer_class: AdventurerClass = AdventurerClass.new()
var portrait: Texture2D = get_random_portrait()
var level: int = 1
var stat_hp: int = 100
var stat_mp: int = 50
var stat_atk: int = 10
var stat_def: int = 5
var stat_mag: int = 1
var stat_res: int = 1
var stat_dex: int = 2
var stat_luk: int = 1
var stat_cha: int = 2

#func _get_property_list() -> Array[Dictionary]:
	#return [
		#{
			#"name": "test_property",
			#"type": TYPE_STRING
		#}
	#]

static func get_random_portrait():
	var portraits = ResourceLoader.list_directory("res://Graphics/Portraits")
	var filename = portraits[randi_range(0, portraits.size() - 1)]
	return load("res://Graphics/Portraits/" + filename)
