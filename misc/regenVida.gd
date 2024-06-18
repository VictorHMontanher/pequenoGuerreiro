extends Node2D

@export var qtdRegen: int = 10


func _ready():
	$Area2D.body_entered.connect(ligarBodyEntered)


func ligarBodyEntered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.cura(qtdRegen)
		player.coletarCarne.emit(qtdRegen)
		queue_free()
