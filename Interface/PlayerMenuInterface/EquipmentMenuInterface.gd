@tool
extends Interface
class_name EquipmentMenuInterface

@onready var equipment_menu: EquipmentMenu = find_child("EquipmentMenu")

func link_object(obj: Variant, node: Node = self):
	if obj and obj is Array[Equipment]:
		if not is_inside_tree():
			await ready
		equipment_menu.link_object(obj)
		return
	super(obj, node)

static func instantiate(items: Array[Equipment] = []) -> EquipmentMenuInterface:
	var interface = preload("res://Interface/PlayerMenuInterface/EquipmentMenuInterface.tscn").instantiate()
	interface.link_object(items)
	return interface
