extends Node2D

signal swaped

const TEXTURES := {
	GameConfig.ItemType.SWORD: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_05.png"),
	GameConfig.ItemType.BOW: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_02.png"),
	GameConfig.ItemType.COIN: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_03.png"),
	GameConfig.ItemType.MEAT: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_04.png")
}

const NO_SELECTION: Vector2i = Vector2i(-1,-1)
var selected: Vector2i = NO_SELECTION

var sprites: Array = []
var board :BoardLogic


func setup(p_board: BoardLogic):
	for r in range(p_board.rows):
		var temp_array := []
		for c in range(p_board.cols):
			var s := Sprite2D.new()
			s.texture = TEXTURES[p_board.grid[r][c].type]
			s.position = Vector2i(c,r) * GameConfig.CELL_SIZE + Vector2i(GameConfig.CELL_SIZE,GameConfig.CELL_SIZE) / 2
			s.scale = Vector2(GameConfig.CELL_SIZE,GameConfig.CELL_SIZE) /s.texture.get_size()
			add_child(s)
			temp_array.append(s)
		sprites.append(temp_array)
	board = p_board
	_add_debug_coords()


# 调试用：在每个格子左上角显示 (x,y) 坐标，方便对照打印信息
func _add_debug_coords() -> void:
	for r in range(board.rows):
		for c in range(board.cols):
			var label := Label.new()
			label.text = "%d,%d" % [c, r]
			label.position = Vector2(c, r) * GameConfig.CELL_SIZE
			label.add_theme_font_size_override("font_size", 10)
			label.add_theme_color_override("font_color", Color.WHITE)
			label.add_theme_color_override("font_outline_color", Color.BLACK)
			label.add_theme_constant_override("outline_size", 4)
			label.z_index = 10
			add_child(label)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var cell := Vector2i((get_local_mouse_position()/GameConfig.CELL_SIZE).floor())
		if cell.x < 0 or cell.x >= GameConfig.COL_COUNT or cell.y < 0 or cell.y >= GameConfig.ROW_COUNT:
			return
		
		if selected == NO_SELECTION:
			selected = cell
			_highlight(sprites[cell.y][cell.x])
		else: 
			if selected == cell:
				selected = NO_SELECTION
				_unhighlight(sprites[cell.y][cell.x])
			elif _is_adjacent(cell,selected):
				board.swap(selected,cell)
				swaped.emit()
				_animate_swap(selected,cell)
				_unhighlight(sprites[selected.y][selected.x])
				_unhighlight(sprites[cell.y][cell.x])
				selected = NO_SELECTION
			else:
				_highlight(sprites[cell.y][cell.x])
				_unhighlight(sprites[selected.y][selected.x])
				selected = cell


func _is_adjacent(new_selected: Vector2i, old_selected: Vector2i) -> bool:
	if (abs(old_selected.x-new_selected.x) + abs(old_selected.y - new_selected.y)) ==1:
		return true
	return false


func _highlight(sprite: Sprite2D):
	sprite.modulate = Color(1, 0, 0.3)


func _unhighlight(sprite: Sprite2D):
	sprite.modulate = Color.WHITE

func _animate_swap(from_vec2: Vector2i, to_vec2:Vector2i):
	var sprite_from: Sprite2D = sprites[from_vec2.y][from_vec2.x]
	var sprite_to: Sprite2D = sprites[to_vec2.y][to_vec2.x]
	var pos_from := sprite_from.position
	var pos_to := sprite_to.position
	
	sprites[from_vec2.y][from_vec2.x] = sprite_to
	sprites[to_vec2.y][to_vec2.x] = sprite_from
	
	var tween: Tween = create_tween()
	tween.tween_property(sprite_from,"position",pos_to,0.15)
	tween.tween_property(sprite_to,"position",pos_from,0.15)
