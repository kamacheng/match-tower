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




func swap(from: Vector2i, to: Vector2i) -> bool:
	var delta := (from - to).abs()
	if delta.x + delta.y != 1:
		return false # 不相邻，拒绝交换
	
	var temp = grid[from.y][from.x].type
	grid[from.y][from.x].type = grid[to.y][to.x].type
	grid[to.y][to.x].type = temp
	find_matches()
	return true


func find_matches():
	for c in range(cols):
		var temp_array: Array = []
		for r in range(rows):
			if temp_array.is_empty():
				temp_array.append(Vector2i(c,r))
			elif grid[r][c].type == grid[r - 1][c].type:
				temp_array.append(Vector2i(c,r))
			else:
				if temp_array.size() >= 3:
					print(temp_array)
				temp_array.clear()
				temp_array.append(Vector2i(c,r))
		if temp_array.size() >= 3:
			print(temp_array)


func debug_print() -> void:
	for row in range(rows):
		var map := []
		for col in range(cols):
			map.append(grid[row][col].type)
		print(map)
