class_name BoardLogic

var rows: int
var cols: int

var grid: Array = []

func _init(p_rows: int, p_cols: int) -> void:
	rows = p_rows
	cols = p_cols
	

	for r in range(rows):
		var temp_array: Array = []
		for c in range(cols):
			temp_array.append({"kind": "item","type": -1})
		grid.append(temp_array)


	for r in range(rows):
		for c in range(cols):
			var type = randi_range(0,GameConfig.ItemType.size() - 1)
			while _check_repeat(r,c,type):
				type = randi_range(0,GameConfig.ItemType.size() - 1)
			grid[r][c].type = type


func _check_repeat(r: int,c: int ,type: int) -> bool:
	if r >= 2 : # 确保脚标不为负
		if type == grid[r-1][c].type and type == grid[r-2][c].type:
			return true
	if c >= 2: # 确保脚标不为负
		if type == grid[r][c-1].type and type == grid[r][c-2].type:
			return true
	return false


func debug_print() -> void:
	for row in range(rows):
		var map := []
		for col in range(cols):
			map.append(grid[row][col].type)
		print(map)
