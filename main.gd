extends Node

@export var gameUI: CanvasLayer
@export var templateGameOver: PackedScene

func _ready():
	GameManager.jogoAcabou.connect(ativarGameOver)

func ativarGameOver():
	if gameUI:
		gameUI.queue_free()
		gameUI = null
	
	var gameOverUI: GameOverUI = templateGameOver.instantiate()
	add_child(gameOverUI)
