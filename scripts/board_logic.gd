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
	
	var temp = grid[from.y][from.x]
	grid[from.y][from.x] = grid[to.y][to.x]
	grid[to.y][to.x] = temp
	#print("Swap: ", find_matches())
	resolve_matches(from,to)
	return true


func find_matches() -> Array:
	var match_v: Array = []
	var match_h: Array = []
	
	for c in range(cols):
		var row_array: Array = []
		for r in range(rows):
			if grid[r][c].kind == "item" and grid[r][c].type != -1:
				if row_array.is_empty():
					row_array.append(Vector2i(c,r))
				elif grid[r][c].type == grid[r - 1][c].type:
					row_array.append(Vector2i(c,r))
				else:
					if row_array.size() >= 3:
						match_v.append(row_array)
					row_array = []
					row_array.append(Vector2i(c,r))
			else :
				if row_array.size() >= 3: # 边界
					match_v.append(row_array)
				row_array = []
		if row_array.size() >= 3: # 边界
			match_v.append(row_array)
			
	
	for r in range(rows):
		var col_array: Array = []
		for c in range(cols):
			if grid[r][c].kind == "item" and grid[r][c].type != -1:
				if col_array.is_empty():
					col_array.append(Vector2i(c,r))
				elif grid[r][c].type == grid[r][c-1].type:
					col_array.append(Vector2i(c,r))
				else:
					if col_array.size() >= 3:
						match_h.append(col_array)
					col_array = []
					col_array.append(Vector2i(c,r))
			else:
				if col_array.size() >= 3: # 边界
					match_h.append(col_array)
				col_array = []
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
			if grid[row][col].kind == "soldier":
				map.append("S" + str(grid[row][col].type))
			else:
				map.append(grid[row][col].type)
		#print(map)


func resolve_matches(from: Vector2i, to: Vector2i):
	var matched := find_matches()
	for group in matched:
		var first: Vector2i = group[0]
		print("Resolve_matched: group: ", group)
		print("Resolve_matched: first: ", group[0])
		var group_type: int = grid[first.y][first.x].type
		print("Resolve_matched: Item_type: " , group_type) # debug_print
		
		var spawn_cell: Vector2i
		for cell in group:
			grid[cell.y][cell.x].type = -1
		if group_type == GameConfig.ItemType.SWORD or group_type == GameConfig.ItemType.BOW:
			if group.has(to):
				spawn_cell = to
			else:
				spawn_cell = from
			grid[spawn_cell.y][spawn_cell.x].kind = "soldier"
			grid[spawn_cell.y][spawn_cell.x].type = group_type
			grid[spawn_cell.y][spawn_cell.x].level = 1
				
				
	debug_print()
