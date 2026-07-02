extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var board := BoardLogic.new(GameConfig.ROW_COUNT, GameConfig.COL_COUNT)
	board.debug_print()
