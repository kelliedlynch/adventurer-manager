@tool
extends ScrollContainer

var units: Array[Adventurer]:
	set(value):
		units = value
		#if not is_inside_tree():
			#await ready
		#_update_unit_list()
		#
		#
#func _update_unit_list():
	#for unit in units:
		#pass

func _ready() -> void:
	#if Engine.is_editor_hint():
		#for i in 10:
			#units.append(Adventurer.new())
	for child in $VBoxContainer.get_children():
		if child is UnitListItem:
			remove_child(child)
			child.queue_free()
	if Engine.is_editor_hint():
		units.clear()
		for i in 10:
			units.append(Adventurer.new())
	else:
		units = Player.roster

	for unit in units:
		var list_item = load("res://GlobalInterface/UnitListItem.tscn").instantiate()
		list_item.unit = unit
		$VBoxContainer.add_child(list_item)
