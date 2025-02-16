@tool
extends ReactiveField
class_name ReactiveMultiField
# A field that displays the contents of an array or dictionary


@onready var values_container: Container = find_child("ValuesContainer")

signal layout_changed

@export var grid_columns: int = 3:
	set(value):
		grid_columns = value
		if not is_inside_tree():
			await ready
		if values_container is GridContainer:
			values_container.columns = value
			
func _init() -> void:
	_internal_vars_list.append("/list_layout")
		
func _ready() -> void:
	
	grid_columns = grid_columns
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		_on_layout_changed(get("/list_layout"))
		var field_values = ["lorem", "ipsum", "dolor", "sit", "amet"]
		print(field_values)
		for child in values_container.get_children():
			child.queue_free()
		for val in field_values:
			var label = Label.new()
			label.text = val
			values_container.add_child(label)
			#if Engine.is_editor_hint():
				#label.owner = self
	layout_changed.connect(_on_layout_changed)
	_on_layout_changed(get("/list_layout"))
	theme_changed.connect(_on_theme_changed)
	_on_theme_changed()
	#super()
func _on_flags_changed():
	var a = size_flags_horizontal
	pass
		
func _on_theme_changed():
	var variation = theme_type_variation
	var font_size = get_theme_font_size("font_size", variation)
	for child in values_container.get_children():
		child.add_theme_font_size_override("font_size", font_size)
			
func _on_layout_changed(value: int) -> void:
	var new_container: Container
	if value == ContentLayout.HORIZONTAL and not values_container is HBoxContainer:
		new_container = HBoxContainer.new()
		var a = new_container.size_flags_horizontal
		new_container.size_flags_horizontal += Control.SIZE_EXPAND
		new_container.size_flags_changed.connect(_on_flags_changed)
		var b = new_container.size_flags_horizontal
		pass
	elif value == ContentLayout.VERTICAL and not values_container is VBoxContainer:
		new_container = VBoxContainer.new()
	elif value == ContentLayout.GRID and not values_container is GridContainer:
		new_container = GridContainer.new()
		new_container.columns = grid_columns
	if new_container != null:
		if values_container != null:
			for child in values_container.get_children():
				child.reparent(new_container)
			values_container.name = "fordeletion"
			values_container.queue_free()
		new_container.name = "ValuesContainer"
		var a = new_container.size_flags_horizontal
		add_child(new_container)
		var b = new_container.size_flags_horizontal
		await new_container.ready
		var c = new_container.size_flags_horizontal
		pass
		if Engine.is_editor_hint() and get_tree().edited_scene_root == self:
			new_container.owner = self
		values_container = new_container
	notify_property_list_changed()

func watch_object(obj: Object):
	linked_model = obj
	var prop = obj.get(get("/linked_property"))
	for child in values_container.get_children():
		child.queue_free()
	if prop and not prop.is_empty():
		var values_list = prop if prop is Array else prop.values()
		for value in values_list:
			_add_value_interface(value)
	if prop:
		if not obj.property_changed.is_connected(_on_property_changed):
			obj.property_changed.connect(_on_property_changed)
			
func _add_value_interface(value):
	var label = Label.new()
	label.text = value
	values_container.add_child(label)

func _on_property_changed(prop_name: String):
	super(prop_name)
	if prop_name == get("/linked_property"):
		var v = linked_model.get(get("/linked_property"))
		var values_list = v if v is Array else v.values()
		for child in values_container.get_children():
			child.queue_free()
		for value in values_list:
			var label = Label.new()
			label.text = str(value)
			values_container.add_child(label)
		theme_changed.emit()

func _set(property, value):
	if property == "/list_layout":
		layout_changed.emit(value)
	super(property, value)

func _reduce_prop_list(accum, val):
	if val.type & (TYPE_DICTIONARY | TYPE_ARRAY):
		return accum + val + ","
	return accum
	
func _get_property_list() -> Array:
	var props = []
	props.append({
		name = "/list_layout",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = contentlayout_hint_string
	})
#
	#if get("/linked_class"):
#
		#props.append({
			#name = "/linked_property",
			#type = TYPE_STRING_NAME,
			#hint = PROPERTY_HINT_ENUM,
			#hint_string = get_property_hint_string()
		#})
	
	
	
	return props
	
func get_property_hint_string() -> String:
	var instance = Utility.instance_class_from_string_name(get("/linked_class"))
	var all_props = instance.get_property_list().filter(func(x): return instance.watchable_props.has(x.name))
	var multi_props = all_props.filter(func(x): return x.type == TYPE_ARRAY or x.type == TYPE_DICTIONARY)
	return multi_props.reduce(func(accum, val): return accum + val.name + ",", "").left(-1)
	
var contentlayout_hint_string = Utility.dict_to_hint_string(ContentLayout)
enum ContentLayout {
	HORIZONTAL,
	VERTICAL,
	GRID
}
