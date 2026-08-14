extends Node2D

@onready var sprite = $Sprite

var value: int = 0

func update_tile(new_value:int):
	value = new_value
	sprite.texture = load("res://tiles/"+str(value)+".png")
