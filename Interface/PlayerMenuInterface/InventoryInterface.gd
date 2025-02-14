extends Menu
class_name InventoryInterface

var items: Array[Equipment]

func _ready() -> void:
	for i in items:
		add_menu_item(InventoryMenuItem.instantiate(i))

static func instantiate(items_list: Array[Equipment]):
	var menu = load("res://Interface/PlayerMenuInterface/InventoryInterface.tscn").instantiate()
	menu.items = items_list
	return menu
