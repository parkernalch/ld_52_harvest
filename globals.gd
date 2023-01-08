extends Node

var flash_rate := 0.4

enum ACTION_TOOLS {
	WATER,
	THRESHER,
	TORCH,
	SEEDBAG
}

# tool size in [ width, height ] format
var tool_size_water = [
	[1, 1, 1],
	[1, 1, 1],
	[1, 1, 1]
]
var tool_size_thresher = [
	[0, 0, 0],
	[1, 1, 1],
	[0, 0, 0]
]
var tool_size_torch = [
	[0, 1, 0],
	[1, 1, 1],
	[0, 1, 0]
]
var tool_size_seedbag = [
	[0, 0, 0],
	[0, 1, 0],
	[0, 0, 0]
]

var tool_char_map = {
	ACTION_TOOLS.WATER : "w",
	ACTION_TOOLS.THRESHER : "p",
	ACTION_TOOLS.TORCH : "b",
	ACTION_TOOLS.SEEDBAG : "s"
}

func get_char_from_active_tool(active_tool):
	return tool_char_map[active_tool];

enum GROWTH_STAGE {
	UNPLANTED,
	SEEDLING,
	BUD,
	FRUITING,
	RIPE,
	DISEASED
}

var char_map = {
	GROWTH_STAGE.UNPLANTED: ".",
	GROWTH_STAGE.SEEDLING: "i",
	GROWTH_STAGE.BUD: "o",
	GROWTH_STAGE.FRUITING: "8",
	GROWTH_STAGE.RIPE: "#",
	GROWTH_STAGE.DISEASED: "?"
}

func get_char_from_growth_stage(growth_stage):
	return char_map[growth_stage];

func random_stage():
	return randi() % len(GROWTH_STAGE)

func next_stage(current_stage):
	var next
	match current_stage:
		GROWTH_STAGE.UNPLANTED:
			next = GROWTH_STAGE.SEEDLING
		GROWTH_STAGE.SEEDLING:
			next = GROWTH_STAGE.BUD
		GROWTH_STAGE.BUD:
			next = GROWTH_STAGE.FRUITING
		GROWTH_STAGE.FRUITING:
			next = GROWTH_STAGE.RIPE
		GROWTH_STAGE.RIPE:
			next = GROWTH_STAGE.UNPLANTED
		_:
			next = GROWTH_STAGE.SEEDLING
	return next
