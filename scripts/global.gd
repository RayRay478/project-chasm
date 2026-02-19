extends Node
enum CHARACTERS {SONIC,TAILS,KNUCKLES}
var player_char = CHARACTERS.SONIC
var characterID = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Matches the CHARACTER per ID 
func _process(_delta: float) -> void:
	match (characterID):
		0: player_char = CHARACTERS.SONIC
		1: player_char = CHARACTERS.TAILS
		2: player_char = CHARACTERS.KNUCKLES
