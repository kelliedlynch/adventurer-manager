extends MenuItemBase
class_name InventoryMenuItem

@onready var item_texture_rect: TextureRect = find_child("ItemTexture")

var item: Equipment = null:
	set(value):
		item = value
		if item:
			if not is_inside_tree():
				await ready
			item_texture_rect.texture = item.texture
			watch_reactive_fields(item, self)

#func _ready() -> void:
	#super()

static func instantiate(equip_item: Equipment):
	var menu = load("res://Interface/PlayerMenuInterface/InventoryMenuItem.tscn").instantiate()
	menu.item = equip_item
	return menu
