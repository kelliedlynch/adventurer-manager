@tool
extends Reactive
class_name DungeonStatusWindow

@onready var unit_list: UnitListMenu = find_child("UnitListMenu")

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		var units: Array[Adventurer] = []
		for i in 4:
			units.append(Adventurer.generate_random_newbie())
		unit_list.link_object(ObservableArray.new(units, Adventurer))

func link_object(obj: Variant, _node: Node = self, _recursive = false):
	var linking_list = obj is Dungeon
	#super(obj, node, linking_list)
	if linking_list:
		if not is_inside_tree(): await ready
		unit_list.link_object(obj.party)

#func layout_party():
	#for child in unit_tiles.get_children():
		#child.queue_free()
	#for unit in linked_object:
		#var tile = UnitSummaryTile.instantiate(unit)
		#unit_tiles.add_child(tile)
