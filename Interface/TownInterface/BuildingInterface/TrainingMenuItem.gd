@tool
extends MenuItemBase
class_name TrainingMenuItem

@onready var trait_name_label: Label = find_child("TraitNameLabel")

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Trait.TraitList.pick_random())
	super()

func link_object(obj: Variant, node: Node = self, recursive = false):
	super(obj, node, recursive)
	if obj is Trait:
		trait_name_label.text = obj.trait_name

static func instantiate(with_trait: Trait) -> UnitListMenu:
	var menu = preload("res://Interface/TownInterface/BuildingInterface/TrainingMenuItem.tscn").instantiate()
	menu.link_object(with_trait)
	return menu
