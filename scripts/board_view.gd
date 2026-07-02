extends Node2D

const TEXTURES := {
	GameConfig.ItemType.SWORD: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_05.png"),
	GameConfig.ItemType.BOW: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_02.png"),
	GameConfig.ItemType.COIN: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_03.png"),
	GameConfig.ItemType.MEAT: preload("res://assets/Tiny Swords (Free Pack)/UI Elements/UI Elements/Icons/Icon_04.png")
}

func setup(p_board: BoardLogic):
	for r in range(p_board.rows):
		for c in range(p_board.cols):
			var s := Sprite2D.new()
			s.texture = TEXTURES[p_board.grid[r][c].type]
			s.position = Vector2i(c,r) * GameConfig.CELL_SIZE + Vector2i(GameConfig.CELL_SIZE,GameConfig.CELL_SIZE) / 2
			s.scale = Vector2(GameConfig.CELL_SIZE,GameConfig.CELL_SIZE) /s.texture.get_size()
			add_child(s)
