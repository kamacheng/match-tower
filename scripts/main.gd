extends Node2D

@onready var board_view := $BoardView
@onready var step_label: Label = $UI/StepLabel
@onready var units := $Units

const SOLDIER_SCENE := preload("res://scenes/soldier.tscn")

var step_count: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var board := BoardLogic.new(GameConfig.ROW_COUNT, GameConfig.COL_COUNT)
	board_view.setup(board)
	board.match_resolved.connect(_on_match_resolved)
	
	board.debug_print()


func _on_board_view_swaped() -> void:
	step_count -= 1
	step_label.text = str(step_count)

func _on_match_resolved(events: Array):
	for event in events:
		if event.event == "spawn":
			var unit: Node2D = SOLDIER_SCENE.instantiate()
			unit.position = board_view.cell_position(event.cell)
			
			units.add_child(unit)
