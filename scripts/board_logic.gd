class_name BoardLogic

var rows: int
var cols: int

var grid: Array = []

func _init(p_rows: int, p_cols: int) -> void:
	rows = p_rows
	cols = p_cols
	
	
	for r in range(rows):
		var row_array: Array = []
		for c in range(cols):
			row_array.append({"kind": "item","type": -1})
		grid.append(row_array)
	
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
	print(find_matches())

	return true


func find_matches() -> Array:
	var match_v: Array = []
	var match_h: Array = []
	
	for c in range(cols):
		var row_array: Array = []
		for r in range(rows):
			if row_array.is_empty():
				row_array.append(Vector2i(c,r))
			elif grid[r][c].type == grid[r - 1][c].type:
				row_array.append(Vector2i(c,r))
			else:
				if row_array.size() >= 3:
					match_v.append(row_array)
				row_array = []
				row_array.append(Vector2i(c,r))
		if row_array.size() >= 3: # 边界
			match_v.append(row_array)
	
	for r in range(rows):
		var col_array: Array = []
		for c in range(cols):
			if col_array.is_empty():
				col_array.append(Vector2i(c,r))
			elif grid[r][c].type == grid[r][c-1].type:
				col_array.append(Vector2i(c,r))
			else:
				if col_array.size() >= 3:
					match_h.append(col_array)
				col_array = []
				col_array.append(Vector2i(c,r))
		if col_array.size() >= 3:
			match_h.append(col_array)
	
	for h_index in range(match_h.size()): # 外层：横
		var is_merged: bool = false
		for v_index in range(match_v.size()):
			if _has_overlap(match_h[h_index],match_v[v_index]): 
				for i in range(match_h[h_index].size()): # 合并重复项
					if !match_v[v_index].has(match_h[h_index][i]):
						match_v[v_index].append(match_h[h_index][i])
				is_merged = true
				break # 没有处理一横连两竖
		if !is_merged:
			match_v.append(match_h[h_index])
	return match_v


func _has_overlap(group_a: Array, group_b: Array) -> bool:	# 工具方法,测试两个组是否重叠
	for index in range(group_a.size()):
		if group_b.has(group_a[index]):
			return true
	return false


func debug_print() -> void:
	for row in range(rows):
		var map := []
		for col in range(cols):
			map.append(grid[row][col].type)
		print(map)


func resolve_matches(form: Vector2i, to: Vector2i):
	var matfched := find_matches()
	
	pass
