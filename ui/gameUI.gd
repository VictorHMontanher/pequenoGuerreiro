extends CanvasLayer

@onready var timerLabel: Label =  $Panel/Timer
@onready var carneLabel: Label =  $Panel2/Carne
@onready var ouroLabel: Label =  $Panel3/Ouro


func _process(delta: float):
	timerLabel.text = GameManager.tempoDecorridoString
	carneLabel.text = str(GameManager.carneQtd)
	ouroLabel.text = str(GameManager.ouroQtd)
