extends Node

var flash_rate := 0.4

var water_level = 10
var seed_stores = 10
var torch_fuel =  10

var crops_harvested = 0 
var crops_spoiled = 0

func _ready():
	EventBus.connect("restart_game", self, "_on_game_restarted")

func _on_game_restarted():
	water_level = 10
	seed_stores = 10
	torch_fuel = 10
	crops_harvested = 0
	crops_spoiled = 0
	EventBus.emit_signal("water_level_changed", 10)
	EventBus.emit_signal("torch_level_changed", 10)
	EventBus.emit_signal("seed_level_changed", 10)
	EventBus.emit_signal("ripe_count_changed", 0)
	EventBus.emit_signal("spoiled_count_changed", 0)

func use_water():
	if water_level == 0:
		return false
	water_level = max(0, water_level - 1)
	EventBus.emit_signal("water_level_changed", water_level)
	return true
	
func use_seed():
	if seed_stores == 0:
		return false
	seed_stores = max(0, seed_stores - 1)
	EventBus.emit_signal("seed_level_changed", seed_stores)
	return true
	
func use_torch():
	if torch_fuel == 0:
		return false
	torch_fuel = max(0, seed_stores - 1)
	EventBus.emit_signal("torch_level_changed", torch_fuel)
	return true

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
