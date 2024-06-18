extends Node2D

@export var qtd: int = 1 

@onready var area2d: Area2D = $Area2D

func dealDamage():
	var corpos = area2d.get_overlapping_bodies()
	for corpo in corpos:
		if corpo.is_in_group("inimigos"):
			var inimigo: Inimigo = corpo
			inimigo.dano(qtd)
