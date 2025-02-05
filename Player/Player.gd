extends Node
#class_name Player

var roster: Array[Adventurer] = []

func _init() -> void:
	print("roster ", roster)
	print("foo")
	for i in 10:
		roster.append(Adventurer.new())

func _ready() -> void:
	print("bar")
