@tool
extends Reactive
class_name TownInterfaceBuilding

@onready var name_label: ReactiveField = find_child("BuildingName")
@onready var description_label: ReactiveField = find_child("BuildingDescription")
@onready var enter_button: Button = find_child("EnterBuilding")

#var building: Building = null:
	#set(value):
		#building = value
		#if building:
			#if not is_inside_tree():
				#await ready
			#watch_reactive_fields(building, self)


#func _ready() -> void:
	#if get_tree().current_scene == self or Engine.is_editor_hint():
			#name_label.text = "Buiding"

static func instantiate(bldg: Building) -> TownInterfaceBuilding:
	var menu = load("res://Interface/TownInterface/TownInterfaceBuilding.tscn").instantiate()
	menu.link_object(bldg)
	return menu
