extends Button
@export var player: CharacterBody3D
@export var character: CharacterBody3D
@export var animation_player: AnimationPlayer
@export var body: Body


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Sonic Button
func _on_pressed() -> void:
	Global.characterID = 0
