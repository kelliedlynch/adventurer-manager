@tool
extends UnitMenuItem
class_name UnitSummaryTile

#@export var show_traits: bool = false:
	#set(value):
		#show_traits = value
		#if not is_inside_tree():
			#await ready
		#traits_container.visible = value
#@export var show_stats: bool = false:
	#set(value):
		#show_stats = value
		#if not is_inside_tree():
			#await ready
		#stats_container.visible = value
#@export var show_buttons: bool = false:
	#set(value):
		#show_buttons = value
		#if not is_inside_tree():
			#await ready
		#buttons_container.visible = value

#@onready var traits_container: Container = find_child("TraitsListContainer")
#@onready var buttons_container: Container = find_child("ActionButtons")
#@onready var stats_container: Container = find_child("StatValuesBlock")
static func instantiate(adv: Adventurer) -> UnitSummaryTile:
	var item = preload("res://Interface/GlobalInterface/UnitList/UnitSummaryTile.tscn").instantiate()
	item.unit = adv
	return item
