@tool
extends Reactive
class_name InventoryInterface

@onready var inventory_menu: Menu = find_child("EquipmentMenu")

func _init() -> void:
	linked_class = "Equipment"

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		var inv: Array[Equipment] = []
		for i in 10:
			inv.append(Equipment.generate_random_equipment())
		link_object(inv)
			
func link_object(obj: Variant, node: Node = self, recursive = false):
	if obj and obj is ObservableArray and obj.array_type == Equipment:
		if not is_inside_tree():
			await ready
		inventory_menu.clear_menu_items()
		for item in obj:
			inventory_menu.add_menu_item(EquipmentMenuItem.instantiate(item))
		return
	super(obj, node, recursive)

static func instantiate(items_list: ObservableArray):
	var menu = load("res://Interface/PlayerMenuInterface/InventoryInterface.tscn").instantiate()
	menu.link_object(items_list)
	return menu
