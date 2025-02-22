extends RefCounted
class_name ObservableArray

var _array: Array = []
var array_type: Variant = null

signal array_changed

var start: int
var current: int
var end: int:
	get: 
		return _array.size()

func _init(from_array: Array = [], of_type: Variant = null):
	_array.append_array(from_array)
	array_type = of_type
	self.start = 0
	self.current = 0
	#self.end = from_array.size() - 1
#func new(from_observable: ObservableArray):
	#_array.append_array(from_observable._array)
	#array_type = from_observable.array_type
	#self.start = 0
	#self.current = 0

func should_continue():
	return current < end

func _iter_init(arg):
	current = start
	return should_continue()

func _iter_next(arg):
	current += 1
	return should_continue()

func _iter_get(arg):
	return _array[current]
	
func is_equal(array: Array):
	return array == _array
	
func all(method: Callable) -> bool:
	return _array.all(method)
func any(method: Callable) -> bool:
	return _array.any(method)
func append(value: Variant) -> void:
	# TODO: don't allow adding stuff if it's the wrong type
	_array.append(value)
	array_changed.emit()
func append_array(array: Variant) -> void:
	if array is ObservableArray:
		_array.append_array(array._array)
	elif array is Array:
		_array.append_array(array)
	else: return
	array_changed.emit()
func assign(array: Array) -> void:
	_array.assign(array)
	array_changed.emit()
func back() -> Variant:
	return _array.back()
func bsearch(value: Variant, before: bool = true) -> int:
	return _array.bsearch(value, before)
func bsearch_custom(value: Variant, callable: Callable, before: bool = true) -> int:
	return _array.bsearch_custom(value, callable, before)
func clear() -> void:
	_array.clear()
	array_changed.emit()
func count(value: Variant) -> int:
	return _array.count(value)
func duplicate(deep: bool = false) -> ObservableArray:
	return ObservableArray.new(_array, array_type)
func erase(value: Variant) -> void:
	_array.erase(value)
	array_changed.emit()
func fill(value: Variant) -> void:
	_array.fill(value)
	array_changed.emit()
func filter(method: Callable) -> Array:
	return _array.filter(method)
func find(what: Variant, from: int = 0) -> int:
	return _array.find(what, from)
func find_custom(method: Callable, from: int = 0) -> int:
	return _array.find_custom(method, from)
func front() -> Variant:
	return _array.front()
#func get(index: int) -> Variant:
	#return _array.get(index)
func get_typed_builtin() -> int:
	# TODO: write this
	return _array.get_typed_builtin()
func get_typed_class_name() -> StringName:
	# TODO: write this
	return _array.get_typed_class_name()
func get_typed_script() -> Variant:
	# TODO: write this
	return _array.get_typed_script()
func has(value: Variant) -> bool:
	return _array.has(value)
func hash() -> int:
	return _array.hash()
func insert(position: int, value: Variant) -> int:
	var r_val = _array.insert(position, value)
	array_changed.emit()
	return r_val
func is_empty() -> bool:
	return _array.is_empty()
func is_read_only() -> bool:
	return _array.is_read_only()
func is_same_typed(array: Array) -> bool:
	# TODO: write this
	return _array.is_same_typed(array)
func is_typed() -> bool:
	return array_type != null
func make_read_only() -> void:
	_array.make_read_only()
	array_changed.emit()
func map(method: Callable) -> Array:
	return _array.map(method)
func max() -> Variant:
	return _array.max()
func min() -> Variant:
	return _array.min()
func pick_random() -> Variant:
	return _array.pick_random()
func pop_at(position: int) -> Variant:
	var r_value = _array.pop_at(position)
	array_changed.emit()
	return r_value
func pop_back() -> Variant:
	var r_value = _array.pop_back()
	array_changed.emit()
	return r_value
func pop_front() -> Variant:
	var r_value = _array.pop_front()
	array_changed.emit()
	return r_value
func push_back(value: Variant) -> void:
	_array.push_back(value)
	array_changed.emit()
func push_front(value: Variant) -> void:
	_array.push_front(value)
	array_changed.emit()
func reduce(method: Callable, accum: Variant = null) -> Variant:
	return _array.reduce(method, accum)
func remove_at(position: int) -> void:
	_array.remove_at(position)
	array_changed.emit()
func resize(size: int) -> int:
	var r_value = _array.resize(size)
	array_changed.emit()
	return r_value
func reverse() -> void:
	_array.reverse()
	array_changed.emit()
func rfind(what: Variant, from: int = -1) -> int:
	return _array.rfind(what, from)
func rfind_custom(method: Callable, from: int = -1) -> int:
	return _array.rfind_custom(method, from)
#func set(index: int, value: Variant) -> void:
	#_array.set(index, value)
func shuffle() -> void:
	_array.shuffle()
	array_changed.emit()
func size() -> int:
	return _array.size()
func slice(begin: int, end: int = 0x7FFFFFFF, step: int = 1, deep: bool = false) -> Array:
	return _array.slice(begin, end, step, deep)
func sort() -> void:
	_array.sort()
	array_changed.emit()
func sort_custom(callable: Callable) -> void:
	_array.sort_custom(callable)
	array_changed.emit()
