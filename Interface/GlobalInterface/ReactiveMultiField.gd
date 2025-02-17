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
			
var dummy_value = ["lorem", "ipsum", "dolor", "sit", "amet"]
			
func _init() -> void:
	_internal_vars_list.append("/list_layout")
		
func _ready() -> void:
	
	grid_columns = grid_columns
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		for val in dummy_value:
			var l = Label.new()
			l.text = val
			values_container.add_child(l)
	layout_changed.connect(_on_layout_changed)
	_on_layout_changed(get("/list_layout"))
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
		new_container.size_flags_horizontal += Control.SIZE_EXPAND
		#new_container.size_flags_changed.connect(_on_flags_changed)
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
		values_container = new_container
		new_container.name = "ValuesContainer"
		add_child(new_container)
		await new_container.ready
		if Engine.is_editor_hint() and get_tree().edited_scene_root == self:
			new_container.owner = self
		
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
			
func _add_value_interface(value):
	var label = Label.new()
	label.text = value
	values_container.add_child(label)

func _set(property, value):
	if property == "/list_layout":
		layout_changed.emit(value)
	super(property, value)

#func _reduce_prop_list(accum, val):
	#if val.type & (TYPE_DICTIONARY | TYPE_ARRAY):
		#return accum + val + ","
	#return accum
func _process(delta: float) -> void:
	if linked_model and get("/linked_property"):
		var val = linked_model.get(get("/linked_property"))
		for child in values_container.get_children():
			child.queue_free()
		for value in val:
			var label = Label.new()
			label.text = str(value)
			values_container.add_child(label)
		theme_changed.emit()
	
func _get_property_list() -> Array:
	var props = []
	props.append({
		name = "/list_layout",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = contentlayout_hint_string
	})
	return props
	
func get_property_hint_string() -> String:
	var instance = Utility.instance_class_from_string_name(get("/linked_class"))
	var all_props = instance.get_property_list()
	var multi_props = all_props.filter(func(x): return x.type == TYPE_ARRAY or x.type == TYPE_DICTIONARY)
	return multi_props.reduce(func(accum, val): return accum + val.name + ",", "").left(-1)
	
var contentlayout_hint_string = Utility.dict_to_hint_string(ContentLayout)
enum ContentLayout {
	HORIZONTAL,
	VERTICAL,
	GRID
}
