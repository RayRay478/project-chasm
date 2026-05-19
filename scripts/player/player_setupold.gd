extends Body

var sonic_model = preload("res://model/CHARACTERS/surivors/sonic.tscn")
var tails_model = preload("res://model/CHARACTERS/surivors/tails.tscn")
var knux_model = preload("res://model/CHARACTERS/surivors/knuckles.tscn")


@export var player_debug: Debug
@onready var playerbody: Node = get_node("Player")

func _ready() -> void:
	super()
	print("help")
	match (Global.player_char):
		
		Global.CHARACTERS.SONIC:
			await get_tree().process_frame
			var sonic = sonic_model.instantiate()
			add_child(sonic)
			animation_player = sonic.get_node("AnimationPlayer")
#			player_debug.health = sonic.get_node("Health")
			playerbody.queue_free()

		Global.CHARACTERS.TAILS:
			await get_tree().process_frame
			var tails = tails_model.instantiate()
			add_child(tails)
			animation_player = tails.get_node("AnimationPlayer")
			player_debug.health = tails.get_node("Health")
			playerbody.queue_free()
			
		Global.CHARACTERS.KNUCKLES:
			await get_tree().process_frame
			var knux = knux_model.instantiate()
			add_child(knux)
			animation_player = knux.get_node("AnimationPlayer")
			player_debug.health = knux.get_node("Health")
			playerbody.queue_free()
