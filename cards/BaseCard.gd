extends MarginContainer


onready var CardDatabase = preload("res://assets/cards/CardsDatabase.gd")
var card_name = "Footman"
onready var card_info = CardDatabase.DATA[CardDatabase.get(card_name)]
onready var card_image = str(
	"res://assets/cards/", card_info[0].to_lower(), "/", card_name, ".png"
)


func _ready():
	var card_size = rect_size
	$Border.scale *= card_size / $Border.texture.get_size()
	$Card.texture = load(card_image)
	$Card.scale *= card_size / $Card.texture.get_size()
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
