extends Node2D

const card_size = Vector2(125, 175)
const BaseCard = preload("res://cards/BaseCard.tscn")
const PlayerHand = preload("res://cards/PlayerHand.gd")
var card_selected = []
onready var deck_size = PlayerHand.CardList.size()

onready var centre_card_oval = get_viewport().size * Vector2(0.5, 1.25)
onready var hor_rad = get_viewport().size.x * 0.45
onready var ver_rad = get_viewport().size.y * 0.4
var angle = deg2rad(90) -0.5
var oval_angle_vector = Vector2()


func draw_card():
	var new_card = BaseCard.instance()
	card_selected = randi() % deck_size
	new_card.card_name = PlayerHand.CardList[card_selected]
	oval_angle_vector = Vector2(hor_rad * cos(angle), - ver_rad * sin(angle))
	new_card.rect_position = centre_card_oval + oval_angle_vector - new_card.rect_size / 2
	new_card.rect_scale *= card_size / new_card.rect_size
	new_card.rect_rotation = (90 - rad2deg(angle)) / 4
	$Cards.add_child(new_card)
	PlayerHand.CardList.erase(PlayerHand.CardList[card_selected])
	angle += 0.2
	deck_size -= 1
	return deck_size
