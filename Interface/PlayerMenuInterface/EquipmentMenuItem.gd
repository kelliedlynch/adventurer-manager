@tool
extends MenuItemBase
class_name EquipmentMenuItem

@onready var item_texture_rect: TextureRect = find_child("ItemTexture")
@onready var item_name_label: Label = find_child("ItemName")

var empty_item_label: String = "(no item)"

func _ready() -> void:
	#item_texture_rect.linked_class = linked_class
	#item_texture_rect.linked_property = "texture"
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Equipment.generate_random_equipment())
	if linked_object == null:
		item_name_label.set_script(null)
		item_name_label.text = empty_item_label
	super()
	
func link_object(obj: Variant, node: Node = self, recursive = true):
	super(obj, node, recursive)

static func instantiate(equip_item: Equipment) -> EquipmentMenuItem:
	var menu_item = load("res://Interface/PlayerMenuInterface/EquipmentMenuItem.tscn").instantiate()
	if equip_item == null:
		menu_item.linked_object = null
	else:
		menu_item.link_object(equip_item)
	return menu_item
