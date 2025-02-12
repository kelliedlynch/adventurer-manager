extends Resource
class_name Utility

static func normalize_range(range: Array):
	var normalized = []
	var minVal  = range.min()
	var maxVal  = float(range.max() - minVal)
	for i in range.size():
		var a = (range[i] - minVal) / maxVal
		normalized.append(a)
	return normalized
