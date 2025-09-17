extends Area2D

signal interacted(frame_id: int)

@export var frame_id: int = 0
@onready var sprite = $Sprite2D

func _ready():
	sprite.frame = frame_id
