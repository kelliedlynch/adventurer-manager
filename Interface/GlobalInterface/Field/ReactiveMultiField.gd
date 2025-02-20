@tool
extends ReactiveField
class_name ReactiveMultiField
# A field that displays the contents of an array or dictionary


var list_layout: int = ContentLayout.VERTICAL:
	set(value):
		list_layout = value
		if not is_inside_tree():
			await ready
		_on_layout_changed(value)

@onready var values_container: Container = find_child("ValuesContainer")

var current_values: Array:
	get:
		return values_container.get_children().map(func(x): return x.text)
	set(_v):
		return

@export var grid_columns: int = 3:
	set(value):
		grid_columns = value
		if not is_inside_tree():
			await ready
		if values_container is GridContainer:
			values_container.columns = value
			
@export var v_separation: int = 8:
	set(value):
		v_separation = value
		if values_container is VBoxContainer:
			values_container.add_theme_constant_override("separation", value)
		if values_container is GridContainer:
			values_container.add_theme_constant_override("v_separation", value)
		#notify_property_list_changed()
			
@export var h_separation: int = 16:
	set(value):
		h_separation = value
		if values_container is HBoxContainer:
			values_container.add_theme_constant_override("separation", value)
		if values_container is GridContainer:
			values_container.add_theme_constant_override("h_separation", value)
		#notify_property_list_changed()
			
@export var fill_horizontal: bool = false:
	set(value):
		fill_horizontal = value
		for child in values_container.get_children():
			child.size_flags_horizontal = Control.SIZE_EXPAND_FILL if value == true else Control.SIZE_SHRINK_CENTER
		notify_property_list_changed()
		
@export var fill_vertical: bool = false:
	set(value):
		fill_vertical = value
		for child in values_container.get_children():
			child.size_flags_vertical = Control.SIZE_EXPAND_FILL if value == true else Control.SIZE_SHRINK_CENTER
		notify_property_list_changed()

func _ready() -> void:
	_on_layout_changed(list_layout)
	theme_changed.connect(_on_theme_changed)
	_on_theme_changed()
		
func _on_theme_changed():
	var variation = theme_type_variation
	var font_size = get_theme_font_size("font_size", variation)
	for child in values_container.get_children():
		child.add_theme_font_size_override("font_size", font_size)
			
func _on_layout_changed(value: int) -> void:
	var new_container: Container
	if value == ContentLayout.HORIZONTAL and not values_container is HBoxContainer:
		new_container = HBoxContainer.new()
		new_container.add_theme_constant_override("separation", h_separation)
		#new_container.size_flags_changed.connect(_on_flags_changed)
	elif value == ContentLayout.VERTICAL and not values_container is VBoxContainer:
		new_container = VBoxContainer.new()
		new_container.add_theme_constant_override("separation", v_separation)
	elif value == ContentLayout.GRID and not values_container is GridContainer:
		new_container = GridContainer.new()
		new_container.columns = grid_columns
		new_container.add_theme_constant_override("h_separation", h_separation)
		new_container.add_theme_constant_override("v_separation", v_separation)
	if new_container != null:
		new_container.size_flags_horizontal += Control.SIZE_EXPAND
		if values_container != null:
			for child in values_container.get_children():
				child.reparent(new_container)
			values_container.name = "fordeletion"
			values_container.queue_free()
		values_container = new_container
		new_container.name = "ValuesContainer"
		add_child(new_container)
		#await new_container.ready
		if Engine.is_editor_hint() and get_tree().edited_scene_root == self:
			new_container.owner = self
		
	notify_property_list_changed()

func watch_object(obj: Object):
	linked_model = obj
	for child in values_container.get_children():
		child.queue_free()
	if linked_property in obj:
		var prop = obj.get(linked_property)
		var values_list = prop if prop is Array else prop.values()
		for value in values_list:
			_add_value_interface(value)
			
func _add_value_interface(value):
	var label = Label.new()
	label.text = value if value else ""
	values_container.add_child(label)
	theme_changed.emit()

func _process(delta: float) -> void:
	if linked_model and linked_property:
		var model_val = linked_model.get(linked_property).map(func(x): return str(x)) 
		if model_val != current_values:
			_clear_values_container()
			for value in model_val:
				_add_value_interface(value)
	
func _get_property_list() -> Array:
	var props = []
	props.append_array([{
		name = "__list_layout",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = Utility.dict_to_hint_string(ContentLayout.orientations)
	},
	{
		name = "__test_value",
		type = TYPE_ARRAY
	}])
	return props
	
func get_test_value(property: StringName):
	if property == "__test_value":
		return values_container.get_children().map(func(x): return x.text) if values_container else []

func set_test_value(property: StringName, value: Variant):
	if not is_inside_tree():
		await ready
	if property == "__test_value":
		_clear_values_container()
		for element in value:
			_add_value_interface(element)

func clear_test_value():
	_clear_values_container()

func _clear_values_container():
	for child in values_container.get_children():
		values_container.remove_child(child)
		child.queue_free()

func _property_get_revert(property: StringName) -> Variant:
	if property == "__test_value":
		return []
	return super(property)
	
func get_property_hint_string() -> String:
	var instance = Utility.instance_class_from_string_name(linked_class)
	var all_props = instance.get_property_list()
	var multi_props = all_props.filter(func(x): return x.type == TYPE_ARRAY or x.type == TYPE_DICTIONARY)
	return multi_props.reduce(func(accum, val): return accum + val.name + ",", "").left(-1)
	
