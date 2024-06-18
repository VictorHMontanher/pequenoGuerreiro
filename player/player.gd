class_name Player

extends CharacterBody2D

@export_category("Movimento")
@export var speed: float = 3

@export_category("Espada")
@export var danoEspada: int = 2

@export_category("Ritual")
@export var danoRitual: int = 1
@export var intervaloRitual: float = 30
@export var cenaRitual: PackedScene

@export_category("Vida")
@export var vida: int = 100
@export var vidaMax: int = 100
@export var templeteMorte: PackedScene

@export_category("Ouro")
@export var ouro: int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animacaoPlayer: AnimationPlayer = $AnimationPlayer
@onready var areaEspada: Area2D = $AreaEspada
@onready var areaHitbox: Area2D = $HitBox
@onready var barraProgressoVida: ProgressBar = $VidaProgressBar

var inputVetor: Vector2 = Vector2(0, 0)
var correndo: bool = false
var estavaCorrendo: bool = false
var atacando: bool = false
var ataqueCooldown: float = 0.0
var hitboxCooldown: float = 0.0
var ritualCooldown: float = 0.0

signal coletarCarne(value: int)
signal coletarOuro(value: int)

func _ready():
	GameManager.player = self
	coletarCarne.connect(func(value: int): GameManager.carneQtd += 1)
	coletarOuro.connect(func(value: int): GameManager.ouroQtd += (1 * 10))

func _process(delta: float):
	GameManager.posicaoJogador = position
	lerInput()

	cooldownAtaque(delta)
	if Input.is_action_just_pressed("attack"):
		ataque()

	animacaoIdleWalk()
	if not atacando:
		rodarSprite()
	
	updateHitbox(delta)
	
	updateRitual(delta)
	
	barraProgressoVida.max_value = vidaMax
	barraProgressoVida.value = vida



func _physics_process(delta: float):
	var targetVelocity = inputVetor * speed * 100.0
	if atacando:
		targetVelocity *= 0.25
	velocity = lerp(velocity, targetVelocity, 0.2)
	move_and_slide()


func lerInput():
	inputVetor = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")

	var deadZone = 0.15
	if abs(inputVetor.x) < 0.15:
		inputVetor.x = 0.0
	if abs(inputVetor.y) < 0.15:
		inputVetor.y = 0.0

	estavaCorrendo = correndo
	correndo = not inputVetor.is_zero_approx()

func ataque():
	if atacando:
		return

	animacaoPlayer.play("attackOne")
	ataqueCooldown = 0.6
	atacando = true

func danoNoInimigo():
	var corpos = areaEspada.get_overlapping_bodies()
	for corpo in corpos:
		if corpo.is_in_group("inimigos"):
			var inimigo: Inimigo = corpo
			
			var direcaoParaInimigo = (inimigo.position - position).normalized()
			var direcaoAtaque: Vector2
			if sprite.flip_h:
				direcaoAtaque = Vector2.LEFT
			else:
				direcaoAtaque = Vector2.RIGHT
			var dotProduto = direcaoParaInimigo.dot(direcaoAtaque)
			print("Dot: ", dotProduto)
			
			if dotProduto >= 0.3:
				inimigo.dano(danoEspada)
				print("Dano: ", danoEspada)
				print("Vida: ", inimigo.vida)

func animacaoIdleWalk():
	if not atacando:
		if estavaCorrendo != correndo:
			if correndo:
				animacaoPlayer.play("walk")
			else:
				animacaoPlayer.play("idle")

func rodarSprite():
	if inputVetor.x > 0 :
		sprite.flip_h = false
	elif inputVetor.x < 0:
		sprite.flip_h = true

func cooldownAtaque(delta: float):
	if atacando:
		ataqueCooldown -= delta
		if ataqueCooldown <= 0.0:
			atacando = false
			correndo = false
			animacaoPlayer.play("idle")

func updateHitbox(delta: float):
	hitboxCooldown -= delta
	if hitboxCooldown > 0: return
	
	hitboxCooldown = 0.5
	
	var corpos = areaHitbox.get_overlapping_bodies()
	for corpo in corpos:
		if corpo.is_in_group("inimigos"):
			var inimigo: Inimigo = corpo
			var danoQtd = 1
			dano(danoQtd)

func dano(qtd: int):
	if vida <= 0: return
	
	vida -= qtd
	
	modulate = Color.ORANGE_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if vida <= 0:
		morte()

func morte():
	GameManager.terminarJogo()
	
	if templeteMorte:
		var objetoMorto = templeteMorte.instantiate()
		objetoMorto.position = position
		get_parent().add_child(objetoMorto)
	
	print("Jogador morreu!")
	queue_free()

func cura(qtd: int):
	vida += qtd
	if vida > vidaMax:
		vida = vidaMax
	print("Player recebeu cura de ", qtd, ". A vida total é de ", vida, "/", vidaMax)
	return vida

func ganharOuro(qtd: int):
	ouro += qtd
	return ouro

func updateRitual(delta: float):
	ritualCooldown -= delta
	if ritualCooldown > 0: return
	ritualCooldown = intervaloRitual
	
	var ritual = cenaRitual.instantiate()
	ritual.qtd = danoRitual
	add_child(ritual)
