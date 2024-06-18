extends Node2D

@export var valor: int = 0

func _ready():
	%Label.text = str(valor)
