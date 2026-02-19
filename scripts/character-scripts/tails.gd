extends PlayerMain
#DOESNT WORK FOR SOME REASON`

func _ready():
	print("huh")
	match (Global.player_char):
		Global.CHARACTERS.TAILS:
			jump_impulse = 50
