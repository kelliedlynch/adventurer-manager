@tool
extends Menu
## Displays a list of adventurers from an ObservableArray, and updates menu items as array changes
class_name UnitListMenu

var menu_item_type: MenuItemType = MenuItemType.PANEL_WIDE:
	set(value):
		menu_item_type = value
		if not is_inside_tree():
			await ready
		_on_menu_item_type_changed(value)
			
var layout_type: int = ContentLayout.VERTICAL:
	set(value):
		if value != layout_type:
			layout_type = value
			if not is_inside_tree():
				await ready
			_on_layout_type_changed(value)
			notify_property_list_changed()
		
var grid_columns: int = 2:
	set(value):
		if value != grid_columns:
			grid_columns = value
			if not is_inside_tree():
				await ready
			if menu_items_container is GridContainer:
				menu_items_container.columns = grid_columns

var registered_buttons: Array[Dictionary] = []

#var _unit_menuitem_map: Dictionary[Adventurer, UnitMenuItem] = {}
#var units: Array[Adventurer]:
	#get:
		#return _unit_menuitem_map.keys()
	#set(value):
		#push_error("can't set units directly; use add/remove functions")

func build_menu_item(unit: Variant) -> MenuItemBase:
	var menu_item_class = UnitListMenuItem
	var new_menu_item: MenuItemBase
	match menu_item_type:
		MenuItemType.PANEL_WIDE:
			new_menu_item = UnitListMenuItem.instantiate(unit)
			new_menu_item.layout_variation = UnitListMenuItem.LayoutVariation.WIDE
		MenuItemType.PANEL_NARROW:
			new_menu_item = UnitListMenuItem.instantiate(unit)
			new_menu_item.layout_variation = UnitListMenuItem.LayoutVariation.NARROW_TRAITS_BELOW
		MenuItemType.TILE:
			new_menu_item = UnitSummaryTile.instantiate(unit)
	new_menu_item.link_object(unit)
	for button in registered_buttons:
		var butt = new_menu_item.add_action_button(button.text, button.action.bind(unit))
		if not button.active_if.call(unit):
			butt.disabled = true
	if not Engine.is_editor_hint() and not Game.player.roster.has(unit):
		if new_menu_item.weapon_slot:
			new_menu_item.weapon_slot.select_disabled = true
		if new_menu_item.armor_slot:
			new_menu_item.armor_slot.select_disabled = true
	return new_menu_item

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		for i in 10:
			add_menu_item(build_menu_item(Adventurer.generate_random_newbie()))

func _on_menu_item_type_changed(_item_type: MenuItemType):
	if not linked_object: return
	build_menu_items()
		
func _on_layout_type_changed(layout: int):
	var items = menu_items_container.get_children()
	items.map(menu_items_container.remove_child)
	var container_parent = menu_items_container.get_parent()
	menu_items_container.name = "fordeletion"
	menu_items_container.queue_free()
	match layout:
		ContentLayout.HORIZONTAL:
			menu_items_container = HBoxContainer.new()
		ContentLayout.VERTICAL:
			menu_items_container = VBoxContainer.new()
		ContentLayout.GRID:
			menu_items_container = GridContainer.new()
			menu_items_container.columns = grid_columns
	menu_items_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_items_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	menu_items_container.name = "MenuItems"
	container_parent.add_child(menu_items_container)
	if get_tree().edited_scene_root == self:
		menu_items_container.owner = self
	for item in items:
		menu_items_container.add_child(item)

#func _refresh_menu() -> void:
	#for item in menu_items:
		#if !_unit_menuitem_map.has(item.unit):
			#remove_menu_item(item)

func register_action_button(text: String, action: Callable, active_if: Callable = func(): pass):
	var dict = {
		"text": text,
		"action": action,
		"active_if": active_if
	}
	registered_buttons.append(dict)

func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = [{
		name = "__menu_item_type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = Utility.dict_to_hint_string(MenuItemType)
	},
	{
		name = "__layout_type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = Utility.dict_to_hint_string(ContentLayout.orientations)
	}]
	if layout_type == ContentLayout.GRID:
		props.append({
			name = "__grid_columns",
			type = TYPE_INT
		})
	return props

static func instantiate(with_units: ObservableArray = ObservableArray.new()) -> UnitListMenu:
	var menu = preload("res://Interface/GlobalInterface/UnitList/UnitListMenu.tscn").instantiate()
	menu.link_object(with_units)
	return menu

enum MenuItemType {
	PANEL_WIDE,
	PANEL_NARROW,
	TILE
}
