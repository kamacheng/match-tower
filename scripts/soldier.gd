extends Node2D

const FRAMES := {
	GameConfig.ItemType.SWORD : preload("res://resources/warrior_frames.tres"),
	GameConfig.ItemType.BOW   : preload("res://resources/archer_frames.tres"),
	}

@onready var anim: AnimatedSprite2D = $ AnimatedSprite2D



func setup(p_type: int) -> void:
	anim.sprite_frames = FRAMES[p_type]
	anim.play("idle")
