@tool
extends Reactive
class_name EquipmentMenuInterface

@onready var equipment_menu: EquipmentMenu = find_child("EquipmentMenu")

func _init() -> void:
	linked_class = "Equipment"

func link_object(obj: Variant, node: Node = self, recursive = true):
	if node == self and obj and obj is ObservableArray and obj.array_type == Equipment:
		if not is_inside_tree():
			await ready
		equipment_menu.link_object(obj)
		#return
	super(obj, node)

static func instantiate(items: ObservableArray) -> EquipmentMenuInterface:
	var interface = preload("res://Interface/PlayerMenuInterface/EquipmentMenuInterface.tscn").instantiate()
	interface.link_object(items)
	return interface
