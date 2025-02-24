@tool
extends UnitMenuItem
class_name UnitSummaryTile

static func instantiate(adv: Adventurer) -> UnitListMenuItem:
	var item = preload("res://Interface/GlobalInterface/UnitList/UnitSummaryTile.tscn").instantiate()
	item.link_object(adv)
	return item
