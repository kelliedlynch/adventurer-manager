@tool
extends ScrollContainer
class_name UnitList

@export var list_title: String = "Unit List":
	set(value):
		if value != list_title:
			list_title = value
			if not is_inside_tree():
				await ready
			$VBoxContainer/ListTitle.text = list_title
			
var list_items: Array[UnitListItem] = []

var _units: Array[Adventurer] = []

func add_unit(unit: Adventurer):
	_units.append(unit)
	_refresh_list()
	
func remove_unit(unit: Adventurer):
	var index = _units.find(unit)
	if index != -1:
		_units.remove_at(index)
		_refresh_list()


func _ready() -> void:
	if Engine.is_editor_hint():
		_units.clear()
		for i in 10:
			_units.append(Adventurer.new())
	_refresh_list()


func _refresh_list() -> void:
	for child in $VBoxContainer.get_children():
		if child is UnitListItem:
			#remove_child(child)
			child.queue_free()
	for unit in _units:
		var list_item = load("res://GlobalInterface/UnitListItem.tscn").instantiate()
		list_item.unit = unit
		$VBoxContainer.add_child(list_item)
		list_items.append(list_item)
