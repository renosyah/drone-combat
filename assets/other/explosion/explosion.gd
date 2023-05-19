extends Spatial
class_name Explosion

signal exploded

onready var _sound = $AudioStreamPlayer3D
onready var _animationPlayer = $AnimationPlayer
onready var _explosive_sound = [
	preload("res://assets/other/explosion/explosion_1.wav"),
	preload("res://assets/other/explosion/explosion_2.wav"),
	preload("res://assets/other/explosion/explosion_3.wav"),
]

func _ready():
	_sound.bus = "sfx"
	_sound.unit_db = Global.sound_amplified
	_sound.unit_size = Global.sound_amplified
	_sound.connect("finished", self, "_on_sound_finished")

func explode():
	_sound.stream = _explosive_sound[rand_range(0, _explosive_sound.size() - 1)]
	_sound.play()
	
	_animationPlayer.play("explode")

func _on_sound_finished():
	emit_signal("exploded")
