extends AnimatedSprite2D

@export var valorOuro: int = 10

func _ready():
	$Area2D.body_entered.connect(ligarBodyEntered)

func ligarBodyEntered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.ganharOuro(valorOuro)
		player.coletarOuro.emit(valorOuro)
		queue_free()
