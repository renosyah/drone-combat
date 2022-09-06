extends Control

export var color :Color = Color.red

onready var _border = $border
onready var _tween = $Tween

func _ready():
	_border.modulate = color
	_border.modulate.a = 0.0

func show_hurt(repeated :bool = false):
	_tween.stop_all()
	_tween.repeat = repeated
	
	_tween.interpolate_property(_border,"modulate:a", 1.0, 0.0, 0.8,Tween.TRANS_SINE)
	_tween.start()
