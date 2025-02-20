@tool
extends PanelContainer
class_name DungeonStatusWindow

@onready var unit_tiles: GridContainer = find_child("UnitTiles")

var party: Array[Adventurer] = []:
	set(value):
		party = value
		if not is_inside_tree():
			await ready
		layout_party()

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		var units: Array[Adventurer] = []
		for i in 4:
			units.append(Adventurer.generate_random_newbie())
		party = units

func layout_party():
	for child in unit_tiles.get_children():
		child.queue_free()
	for unit in party:
		var tile = UnitSummaryTile.instantiate(unit)
		unit_tiles.add_child(tile)
