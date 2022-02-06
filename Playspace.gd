extends Node2D

const card_size = Vector2(125, 175)
const BaseCard = preload("res://cards/BaseCard.tscn")
const PlayerHand = preload("res://cards/PlayerHand.gd")
var card_selected = []
onready var deck_size = PlayerHand.CardList.size()

onready var centre_card_oval = get_viewport().size * Vector2(0.5, 1.25)
onready var hor_rad = get_viewport().size.x * 0.45
onready var ver_rad = get_viewport().size.y * 0.4
var angle = 0
var card_number = 0
var hand_card_size = 0
var card_spreed = 0.25
var oval_angle_vector = Vector2()
enum{
	IN_HAND,
	IN_PLAY,
	IN_MOUSE,
	HAND_FOCUS,
	DRAW_TO_HAND,
	REORGANISING
}

func draw_card():
	angle = PI / 2 + card_spreed * (float(hand_card_size) / 2 - hand_card_size)
	var new_card = BaseCard.instance()
	card_selected = randi() % deck_size
	new_card.card_name = PlayerHand.CardList[card_selected]
	oval_angle_vector = Vector2(hor_rad * cos(angle), - ver_rad * sin(angle))
	new_card.start_position = $Deck.position - card_size / 2
	new_card.target_position = centre_card_oval + oval_angle_vector - card_size
	new_card.start_rotation = 0
	new_card.target_rotation = (90 - rad2deg(angle)) / 4
	new_card.rect_scale *= card_size / new_card.rect_size
	new_card.state = DRAW_TO_HAND
	card_number = 0
	for Card in $Cards.get_children():
		angle = PI / 2 + card_spreed * (float(hand_card_size) / 2 - card_number)
		oval_angle_vector = Vector2(hor_rad * cos(angle), - ver_rad * sin(angle))
		Card.target_position = centre_card_oval + oval_angle_vector - card_size
		Card.start_rotation = Card.rect_rotation
		Card.target_rotation = (90 - rad2deg(angle)) / 4
		card_number += 1
		if Card.state == IN_HAND:
			Card.start_position = Card.rect_position
			Card.state = REORGANISING
		elif Card.state == DRAW_TO_HAND:
			Card.start_position = Card.target_position - (
				(Card.target_position - Card.rect_position) / (1 - Card.t)
			)

	$Cards.add_child(new_card)
	PlayerHand.CardList.erase(PlayerHand.CardList[card_selected])
	angle += 0.25
	deck_size -= 1
	hand_card_size += 1
	card_number += 1
	return deck_size
