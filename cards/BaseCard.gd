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
onready var original_scale = rect_scale.x


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
			pass
		DRAW_TO_HAND:
			if t <= 1:
				rect_position = start_position.linear_interpolate(target_position, t)
				rect_rotation = start_rotation * (1 - t) + (target_rotation * t)
				rect_scale.x = original_scale * abs(1 - 2 * t)
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
			if t <= 1:
				rect_position = start_position.linear_interpolate(target_position, t)
				rect_rotation = start_rotation * (1 - t) + (target_rotation * t)
				t += delta / float(ORGANISE_TIME)
			else:
				rect_position = target_position
				rect_rotation = target_rotation
				state = IN_HAND
				t = 0
