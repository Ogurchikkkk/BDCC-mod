extends "res://Modules/AnalBeadsNiki/AnalBeads.gd"

func _init():
	id = "AnalBeadsW"
	depth = 1
	length = RNG.randi_range(3,8)
	firstsize = 1 #?
	numbered = false
	widening = true
	isin = true


func loadData(data):
	.loadData(data)

	depth = SAVE.loadVar(data, "depth", 1)
	length = SAVE.loadVar(data, "length", 5)
	firstsize = SAVE.loadVar(data, "firstsize", 1)
	numbered = SAVE.loadVar(data, "numbered", false)
	widening = SAVE.loadVar(data, "widening", true)
	isin = SAVE.loadVar(data, "isin", true)
