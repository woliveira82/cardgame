extends MarginContainer


onready var CardDatabase = preload("res://assets/cards/CardsDatabase.gd")
var card_name = "Footman"
onready var card_info = CardDatabase.DATA[CardDatabase.get(card_name)]
onready var card_image = str(
	"res://assets/cards/", card_info[0].to_lower(), "/", card_name, ".png"
)
var start_position = 0
var target_position = 0
var start_rotation = 0
var target_rotation = 0
var t = 0
const DRAW_TIME = 0.8
const ORGANISE_TIME = 0.4
const ZOOM_TIME = 0.2
const ZOOM_SIZE = 2
onready var original_scale = rect_scale
var setup = true
var start_scale = Vector2()
var card_position = Vector2()
var reorganise_neighbors = true
var hand_card_size = 0
var card_number = 0
var NeighborCard
var move_neighbor_check = false

enum{
	IN_HAND,
	IN_PLAY,
	IN_MOUSE,
	HAND_FOCUS,
	DRAW_TO_HAND,
	REORGANISING
}
var state = IN_HAND


func _ready():
	var card_size = rect_size
	$Border.scale *= card_size / $Border.texture.get_size()
	$Card.texture = load(card_image)
	$Card.scale *= card_size / $Card.texture.get_size()
	$CardBack.scale *= card_size / $CardBack.texture.get_size()
	$Focus.rect_scale *= card_size / $Card.texture.get_size()
	
	var attack = str(card_info[1])
	var retaliation = str(card_info[2])
	var health = str(card_info[3])
	var cost = str(card_info[4])
	var special_text = str(card_info[6])
	$Bars/TopBar/Name/CenterContainer/Name.text = card_name
	$Bars/TopBar/Cost/CenterContainer/Cost.text = cost
	$Bars/SpecialText/Name/CenterContainer/Type.text = special_text
	$Bars/BottomBar/Attack/CenterContainer/AnR.text = str(attack , " / ", retaliation)
	$Bars/BottomBar/Health/CenterContainer/Health.text = health


func _physics_process(delta):
	match state:
		IN_HAND:
			pass
		IN_PLAY:
			pass
		IN_MOUSE:
			pass
		HAND_FOCUS:
			if setup:
				reset()
			if t <= 1:
				rect_position = start_position.linear_interpolate(target_position, t)
				rect_rotation = start_rotation * (1 - t) + 0 * t
				rect_scale = start_scale * (1 - t) + original_scale * t * ZOOM_SIZE
				t += delta / float(ZOOM_TIME)
				if reorganise_neighbors:
					reorganise_neighbors = false
					hand_card_size = $"../../".hand_card_size - 1
					if card_number - 1 >= 0:
						move_neighbor_card(card_number - 1, true, 1.0)
					if card_number - 2 >= 0:
						move_neighbor_card(card_number - 2, true, 0.25)
					if card_number + 1 <= hand_card_size:
						move_neighbor_card(card_number + 1, false, 1.0)
					if card_number + 2 <= hand_card_size:
						move_neighbor_card(card_number + 2, false, 0.25)
			else:
				rect_position = target_position
				rect_rotation = 0
				rect_scale = original_scale * ZOOM_SIZE
		DRAW_TO_HAND:
			if setup:
				reset()
			if t <= 1:
				rect_position = start_position.linear_interpolate(target_position, t)
				rect_rotation = start_rotation * (1 - t) + target_rotation * t
				rect_scale.x = original_scale.x * abs(2 * t - 1)
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta / float(DRAW_TIME)
			else:
				rect_position = target_position
				rect_rotation = target_rotation
				state = IN_HAND
				t = 0
		REORGANISING:
			if setup:
				reset()
			if t <= 1:
				if move_neighbor_check:
					move_neighbor_check = false
				rect_position = start_position.linear_interpolate(target_position, t)
				rect_rotation = start_rotation * (1 - t) + target_rotation * t
				rect_scale = start_scale * (1 - t) + original_scale * t
				t += delta / float(ORGANISE_TIME)
				if reorganise_neighbors == false:
					reorganise_neighbors = true
					if card_number - 1 >= 0:
						reset_cards_position(card_number - 1)
					if card_number - 2 >= 0:
						reset_cards_position(card_number - 2)
					if card_number + 1 <= hand_card_size:
						reset_cards_position(card_number + 1)
					if card_number + 2 <= hand_card_size:
						reset_cards_position(card_number + 2)
			else:
				rect_position = target_position
				rect_rotation = target_rotation
				rect_scale = original_scale
				state = IN_HAND


func move_neighbor_card(card_index, left, spread_factor):
	NeighborCard = $"../".get_child(card_index)
	if left:
		NeighborCard.target_position = NeighborCard.card_position - spread_factor * Vector2(65, 0)
	else:
		NeighborCard.target_position = NeighborCard.card_position + spread_factor * Vector2(65, 0)
	NeighborCard.setup = true
	NeighborCard.state = REORGANISING
	NeighborCard.move_neighbor_check = true


func reset_cards_position(card_index):
	NeighborCard = $"../".get_child(card_index)
	if NeighborCard.move_neighbor_check == false:
		NeighborCard = $"../".get_child(card_index)
		if NeighborCard.state != HAND_FOCUS:
			NeighborCard.state = REORGANISING
			NeighborCard.target_position = NeighborCard.card_position
			NeighborCard.setup = true


func reset():
	start_position = rect_position
	start_rotation = rect_rotation
	start_scale = rect_scale
	t = 0
	setup = false


func _on_Focus_mouse_entered():
	match state:
		IN_HAND, REORGANISING:
			setup = true
			target_position = card_position
			target_position.y = get_viewport().size.y - $"../../".card_size.y * ZOOM_SIZE
			state = HAND_FOCUS


func _on_Focus_mouse_exited():
	match state:
		HAND_FOCUS:
			setup = true
			target_position = card_position
			state = REORGANISING
