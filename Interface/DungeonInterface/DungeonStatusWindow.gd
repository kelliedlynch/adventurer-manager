@tool
extends Reactive
class_name DungeonStatusWindow

@onready var unit_list: UnitListMenu = find_child("UnitListMenu")

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		var units: Array[Adventurer] = []
		for i in 4:
			units.append(Adventurer.generate_random_newbie())
		link_object(ObservableArray.new(units, Adventurer))

func update_from_linked_object():
	pass

#func layout_party():
	#for child in unit_tiles.get_children():
		#child.queue_free()
	#for unit in linked_object:
		#var tile = UnitSummaryTile.instantiate(unit)
		#unit_tiles.add_child(tile)
