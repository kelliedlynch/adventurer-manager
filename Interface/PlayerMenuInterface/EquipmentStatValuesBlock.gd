@tool
extends Reactive
class_name EquipmentStatValuesBlock

@onready var values_container: Container = find_child("ValuesContainer")
@onready var stat_hp_container: Container = find_child("StatHp")
@onready var stat_atk_label: TextureRect = find_child("StatAtkLabel")

static var phys_atk_icon: Texture2D = load("res://Graphics/Icons/White/basic_sword.png")
static var mag_atk_icon: Texture2D = load("res://Graphics/Icons/White/magic_staff.png")

@export var show_hp: bool = true:
	set(value):
		show_hp = value
		if not is_inside_tree(): await ready
		stat_hp_container.visible = value
@export var show_zeros: bool = true:
	set(value):
		show_zeros = value
		if not is_inside_tree(): await ready
		for child in values_container.get_children():
			if value == true:
				if not show_hp and child == stat_hp_container:
					child.visible = false
				else:
					child.visible = true
				continue
			#print("children on  ", child.name)
			#for sub in child.get_children():
				#print(child.find_child(child.name + "Value"))
				#print(sub.name)
			var field = child.get_node(child.name + "Value")
			if field.linked_object and field.linked_object.get(child.name.to_snake_case()) == 0:
				child.visible = false
				
@export var v_separation: int = 36:
	set(value):
		v_separation = value
		if not is_inside_tree(): await ready
		match layout_type:
			ContentLayout.VERTICAL:
				values_container.add_theme_constant_override("separation", v_separation)
			ContentLayout.GRID:
				values_container.add_theme_constant_override("v_separation", v_separation)
@export var h_separation: int = 20:
	set(value):
		h_separation = value
		if not is_inside_tree(): await ready
		match layout_type:
			ContentLayout.HORIZONTAL:
				values_container.add_theme_constant_override("separation", h_separation)
			ContentLayout.GRID:
				values_container.add_theme_constant_override("h_separation", h_separation)


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
		var dummy = WithStats.new()
		dummy.damage_type = WithStats.DamageType.PHYSICAL if randi() & 1 else WithStats.DamageType.MAGIC
		for stat in dummy.base_stats:
			if stat == Stats.stat_hp.property_name:
				dummy.set(stat, randi_range(0, 16))
			else:
				dummy.set(stat, randi_range(0, 6))
		link_object(dummy, self, true)
	for child in get_children():
		if child.name.begins_with("Stat"):
			var lower = child.name.to_snake_case()
			var stat = Stats.get(lower)
			child.tooltip_text = stat.abbreviation + ": " + stat.description

func update_from_linked_object():
	if not is_inside_tree(): await ready
	if not linked_object: 
		values_container.get_children().map(set.bind("visible", false).unbind(1))
		return
	stat_atk_label.texture = phys_atk_icon if linked_object.damage_type == CombatUnit.DamageType.PHYSICAL else mag_atk_icon
	for child in values_container.get_children():
		var vis = false
		var label_name = child.name + "Value"
		var children = child.get_children()
		var val_label = child.get_node(label_name)
		if val_label:
			#if not linked_object: 
				#if val_label.linked_objecct
			for stat in linked_object.base_stats:
				if val_label.linked_property == stat:
					if (show_zeros or linked_object.get(stat) > 0):
						if val_label.linked_property == Stats.stat_hp.property_name:
							vis = show_hp
						else:
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
			values_container.add_theme_constant_override("separation", h_separation)
		ContentLayout.VERTICAL:
			values_container = VBoxContainer.new()
			values_container.add_theme_constant_override("separation", v_separation)
		ContentLayout.GRID:
			values_container = GridContainer.new()
			values_container.columns = grid_columns
			values_container.add_theme_constant_override("v_separation", v_separation)
			values_container.add_theme_constant_override("h_separation", h_separation)
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
		
func _get_linkable_class_hint_string() -> String:
	var classes = ProjectSettings.get_global_class_list().filter(func(x): return Utility.is_derived_from(x.class, "WithStats")).map(func(x): return x.class)
	var hint_str = Utility.array_to_hint_string(classes)
	return hint_str
	
func _set(property, value):
	# This is solely to allow updating linked class and property in the editor
	if property == "__linked_class":
		set(property.right(-2), value)
		if not is_inside_tree(): await ready
		for child in values_container.get_children():
			for sub in child.get_children():
				if sub is Reactive:
					sub.linked_class = value
		notify_property_list_changed()
		return true
	return false
	
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
