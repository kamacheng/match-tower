extends Node2D

@onready var board_view := $BoardView
@onready var step_label: Label = $UI/StepLabel

var step_count: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var board := BoardLogic.new(GameConfig.ROW_COUNT, GameConfig.COL_COUNT)
	board_view.setup(board)
	
	board.debug_print()


func _on_board_view_swaped() -> void:
	step_count -= 1
	step_label.text = str(step_count)
