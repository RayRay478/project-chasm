extends Node3D

@export var player : PlayerMain 
@export var body : Body
@export var debug : Debug

var sonic_model = preload("res://model/CHARACTERS/surivors/sonic.tscn")
var tails_model = preload("res://model/CHARACTERS/surivors/tails.tscn")
var knux_model = preload("res://model/CHARACTERS/surivors/knuckles.tscn")

#@onready var playerbody: Node = get_node(".")

func _ready() -> void:
	
	match (Global.player_char):
		
		Global.CHARACTERS.SONIC:
			await get_tree().process_frame
			var sonic = sonic_model.instantiate()
			add_child(sonic)
			body = sonic.get_node("PlayerMain/Body")
			player = sonic.get_node("PlayerMain")
			player.camera.make_current()
			player.camera.current = is_multiplayer_authority()
			#self.queue_free()

		Global.CHARACTERS.TAILS:
			await get_tree().process_frame
			var tails = tails_model.instantiate()
			add_child(tails)
			body = tails.get_node("PlayerMain/Body")
			player = tails.get_node("PlayerMain")
			player.camera.make_current()
			player.camera.current = is_multiplayer_authority()

		Global.CHARACTERS.KNUCKLES:
			await get_tree().process_frame
			var knux = knux_model.instantiate()
			add_child(knux)
			body = knux.get_node("PlayerMain/Body")
			player = knux.get_node("PlayerMain")
			player.camera.make_current()
			player.camera.current = is_multiplayer_authority()
