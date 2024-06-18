class_name Inimigo
extends Node2D

@export_category("Vida")
@export var vida: int = 10
@export var templeteMorte: PackedScene
var prefabDano: PackedScene

@onready var digitoDanoMarcador = $DigitoDanoMarcador

@export_category("Drops")
@export var chanceDrop: float = 0.2
@export var itensDrop: Array[PackedScene]
@export var chancesDeDrop: Array[float]

func _ready():
	prefabDano = preload("res://misc/danoDigito.tscn")

func dano(qtd: int):
	vida -= qtd
	
	modulate = Color.ORANGE_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	var danoDigito = prefabDano.instantiate()
	danoDigito.valor = qtd
	if digitoDanoMarcador:
		danoDigito.global_position = digitoDanoMarcador.global_position
	else:
		danoDigito.global_position = global_position
	get_parent().add_child(danoDigito)
	
	if vida <= 0:
		morte()

func morte():
	if templeteMorte:
		var objetoMorto = templeteMorte.instantiate()
		objetoMorto.position = position
		get_parent().add_child(objetoMorto)
	
	if randf() <= chanceDrop:
		dropItem()
	
	GameManager.monstroQtd += 1
	
	queue_free()

func dropItem():
	var drop = getDropAleatorio().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func getDropAleatorio() -> PackedScene:
	if itensDrop.size() == 1:
		return itensDrop[0]
	
	var chanceMax: float = 0.0
	for chanceDrop in chancesDeDrop:
		chanceMax += chanceDrop
	
	var valorAleatorio = randf() * chanceMax
	
	var aleatorio: float = 0.0
	for i in itensDrop.size():
		var dropItem = itensDrop[i]
		var chanceDrop = chancesDeDrop[i] if i < chancesDeDrop.size() else 1
		if valorAleatorio <= chanceDrop + aleatorio:
			return dropItem
		aleatorio += chanceDrop
	
	return itensDrop[0]
