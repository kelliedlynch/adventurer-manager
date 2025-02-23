@tool
extends Reactive
class_name DungeonHazardIcon

var dungeon: Dungeon

@export var icon_size: Vector2:
	set(value):
		icon_size = value
		icon_texture.custom_minimum_size = value

@onready var icon_border: PanelContainer = find_child("IconBorder")
@onready var icon_texture: TextureRect = find_child("IconTexture")

func _ready():
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Hazard.new())
		
func link_object(obj: Variant, node: Node = self, recursive = true):
	if obj is Dungeon:
		dungeon = obj
	super(obj, node, recursive)
	
func _make_custom_tooltip(_a) -> Object:
	var tt = load("res://Interface/GlobalInterface/Tooltip/DungeonHazardTooltip.tscn").instantiate()
	tt.link_object(linked_object)
	return tt

func update_from_linked_object():
	if not Engine.is_editor_hint():
		var box: String
		match linked_object.get_mitigated_state(dungeon):
			Hazard.MitigatedState.PARTIAL:
				box = "hazard_partial_active"
			Hazard.MitigatedState.INACTIVE:
				box = "hazard_inactive"
			_:
				box = "panel"
		remove_theme_stylebox_override("panel")
		icon_border.add_theme_stylebox_override("panel", get_theme_stylebox(box, icon_border.theme_type_variation))
		add_theme_stylebox_override("panel", get_theme_stylebox(box, theme_type_variation))
	super()

static func instantiate(haz: Hazard, dun: Dungeon) -> DungeonHazardIcon:
	var menu = load("res://Interface/DungeonInterface/DungeonHazardIcon.tscn").instantiate()
	menu.link_object(haz)
	menu.link_object(dun)
	return menu
