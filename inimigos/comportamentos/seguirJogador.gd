extends Node

@export var speed = 1.0

var enemy: Inimigo
var sprite: AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta: float):
	if GameManager.gameOver: return
	
	var posicaoPlayer = GameManager.posicaoJogador
	var diferenca = posicaoPlayer - enemy.position
	var inputVetor = diferenca.normalized()

	enemy.velocity = inputVetor * speed * 100.0
	enemy.move_and_slide()

	if inputVetor.x > 0 :
		sprite.flip_h = false
	elif inputVetor.x < 0:
		sprite.flip_h = true
