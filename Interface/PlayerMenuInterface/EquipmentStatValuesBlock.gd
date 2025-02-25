@tool
extends Reactive
class_name EquipmentStatValuesBlock

@onready var values_container: Container = find_child("ValuesContainer")

#func link_object(obj: Variant, node: Node = self, recursive = false):
	#if node == self and obj is Equipment:
		#pass
	#else:
		#super(obj, node, recursive)
	
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
			if values_container is GridContainer:
				values_container.columns = grid_columns
				
func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Equipment.generate_random_equipment())

func update_from_linked_object():
	if not linked_object: 
		values_container.get_children().map(set.bind("visible", false).unbind(1))
		return
	for child in values_container.get_children():
		var vis = false
		var label_name = child.name + "Value"
		var children = child.get_children()
		var val_label = child.get_node(label_name)
		if val_label:
			#if not linked_object: 
				#if val_label.linked_objecct
			var stat_mods = linked_object.base_stats.keys()
			for stat in stat_mods:
				if val_label.linked_property == stat and linked_object.get(stat) > 0:
					vis = true
					break
		child.visible = vis

func _on_layout_type_changed(layout: int):
	var items = values_container.get_children()
	items.map(values_container.remove_child)
	var container_parent = values_container.get_parent()
	values_container.name = "fordeletion"
	values_container.queue_free()
	match layout:
		ContentLayout.HORIZONTAL:
			values_container = HBoxContainer.new()
		ContentLayout.VERTICAL:
			values_container = VBoxContainer.new()
		ContentLayout.GRID:
			values_container = GridContainer.new()
			values_container.columns = grid_columns
	values_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	values_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	#menu_items_container.alignment = VERTICAL_ALIGNMENT_CENTER
	values_container.name = "ValuesContainer"
	container_parent.add_child(values_container)
	for item in items:
		values_container.add_child(item)
	if get_tree().edited_scene_root == self:
		_set_owner(values_container)
			
func _set_owner(node: Node):
		node.owner = self
		for child in node.get_children():
			_set_owner(child)
		
func link_object(obj: Variant, node: Node = self, recursive = false):
	if obj and obj is Equipment:
		recursive = true
	super(obj, node, recursive)
	
func unlink_object(obj: Variant, node: Node = self, recursive = false):
	if obj == linked_object:
		recursive = true
	super(obj, node, recursive)
		
func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = [
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

func _property_get_revert(property: StringName) -> Variant:
	if property == "__layout_type":
		return ContentLayout.HORIZONTAL
	if property == "__grid_columns":
		return 6
	return super(property)
