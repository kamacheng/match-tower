extends Node2D

@onready var board_view := $BoardView

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var board := BoardLogic.new(GameConfig.ROW_COUNT, GameConfig.COL_COUNT)

	board_view.setup(board)
	
	board.debug_print()
