@tool
extends VBoxContainer
class_name UnitList

@export var list_title: String = "Unit List":
	set(value):
		if value != list_title:
			list_title = value
			if not is_inside_tree():
				await ready
			$ListTitle.text = list_title
			
@onready var list_items: VBoxContainer = $ScrollContainer/ListItems

var _units: Array[Adventurer]:
	set(value):
		_units = value
		_refresh_list()
		
func remove_list_item(item: UnitListItem):
	item.queue_free()
	
func add_list_item(item: UnitListItem):
	list_items.add_child(item)

func _ready() -> void:
	if get_tree().root.get_children().has(self):
		for i in 10:
			var adv = Adventurer.new()
			adv.name = "Dummy Adventurer"
			_units.append(adv)
	_refresh_list()

func test(foo):
	return foo.unit == null

func _refresh_list() -> void:
	var new_list: Array[UnitListItem] = []
	var existing_items = list_items.get_children()
	for unit in _units:
		var index = existing_items.find_custom(func (x): return x.unit == unit)
		if index != -1:
			new_list.append(existing_items[index])
			existing_items[index] = null
		else:
			var new_item = UnitListItem.instantiate()
			new_item.unit = unit
			new_list.append(new_item)
	if new_list != existing_items:
		for item in existing_items:
			remove_list_item(item)
		for item in new_list:
			add_list_item(item)
