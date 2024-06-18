class_name GameOverUI
extends CanvasLayer

@onready var labelTempo: Label = %LabelTempo
@onready var labelMonstro: Label = %LabelMonstros

@export var restartDelay: float = 5.0
var restartCooldown: float

func _ready():
	labelTempo.text = GameManager.tempoDecorridoString
	labelMonstro.text = str(GameManager.monstroQtd)
	restartCooldown = restartDelay

func _process(delta):
	restartCooldown -= delta
	if restartCooldown <= 0.0:
		restartJogo()

func restartJogo():
	GameManager.reset()
	get_tree().reload_current_scene()
