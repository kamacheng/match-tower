extends Node2D

const TEXTURES := {
	GameConfig.ItemType.SWORD: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_05.png"),
	GameConfig.ItemType.BOW: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_02.png"),
	GameConfig.ItemType.COIN: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_03.png"),
	GameConfig.ItemType.MEAT: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_04.png")
}

const NO_SELLECTION: Vector2i = Vector2i(-1,-1)
var selected: Vector2i = NO_SELLECTION

var sprites: Array = []



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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var cell := Vector2i((get_local_mouse_position()/GameConfig.CELL_SIZE).floor())
		if cell.x < 0 or cell.x >= GameConfig.COL_COUNT or cell.y < 0 or cell.y >= GameConfig.ROW_COUNT:
			return
		selected = cell
		_hifhtlight(sprites[cell.y][cell.x])
	
	if selected != NO_SELLECTION:
		pass


func _hifhtlight(sprite: Sprite2D):
	sprite.modulate = Color(1, 0, 0.3)


func _unhightlight(sprite: Sprite2D):
	sprite.modulate = Color.WHITE
	
