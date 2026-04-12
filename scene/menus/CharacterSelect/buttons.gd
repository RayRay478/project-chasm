extends TextureButton
var tween: Tween
@export var sound: AudioStreamPlayer
@export var selector: Selector

func _ready() -> void:
	pivot_offset = size / 2
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.4)
	$"../MenuBleep".play()

func _on_mouse_exited() -> void:
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)

func _on_pressed() -> void:
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.65)
	sound.play()
	$"../MenuAccept".play()
#	selector.which_pressed()

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
