extends Node

@onready var multiplayer_ui = $CanvasLayer

const PLAYER = preload("res://entity/characternew.tscn")

var peer = ENetMultiplayerPeer.new()

func _on_host_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	peer.create_server(2515)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(
		func(pid):
			print("frinend " + str(pid) + " has joined the game!")
			add_player(pid)
	)
	
	add_player(multiplayer.get_unique_id())
	multiplayer_ui.hide()

func _on_join_pressed():
	peer.create_client("localhost", 2515)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()

func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	add_child(player)
