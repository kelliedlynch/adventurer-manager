@tool
extends Node

static var Mage = ClassMage.new()
static var Warrior = ClassWarrior.new()
static var Healer = ClassHealer.new()

func random() -> Variant:
	var classes = [
		Warrior, Mage, Healer
	]
	return classes.pick_random()
