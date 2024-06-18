extends Node

signal jogoAcabou

var player: Player
var posicaoJogador: Vector2
var gameOver: bool = false

var tempoDecorrido: float = 0.0
var tempoDecorridoString: String
var carneQtd: int = 0
var ouroQtd: int = 0
var monstroQtd: int = 0

func _process(delta):
	tempoDecorrido += delta
	var tempoDecorridoSegundos: int = floori(tempoDecorrido)
	var seg: int = tempoDecorridoSegundos % 60
	var min: int = tempoDecorridoSegundos / 60
	
	tempoDecorridoString = "%02d:%02d" % [min, seg]

func terminarJogo():
	if gameOver: return
	gameOver = true
	jogoAcabou.emit()

func reset():
	player = null
	posicaoJogador = Vector2.ZERO
	gameOver = false
	
	tempoDecorrido = 0.0
	tempoDecorridoString = "00:00"
	carneQtd = 0
	ouroQtd = 0
	monstroQtd = 0
