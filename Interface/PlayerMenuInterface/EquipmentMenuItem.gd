@tool
extends MenuItemBase
class_name EquipmentMenuItem

@onready var item_texture_rect: TextureRect = find_child("ItemTexture")

func _ready() -> void:
	#item_texture_rect.linked_class = linked_class
	#item_texture_rect.linked_property = "texture"
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Equipment.generate_random_equipment())
	super()

static func instantiate(equip_item: Equipment):
	var menu = load("res://Interface/PlayerMenuInterface/EquipmentMenuItem.tscn").instantiate()
	menu.link_object(equip_item)
	return menu
