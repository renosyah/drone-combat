extends Spatial

onready var _message_3d = $message_3d 
onready var _tween = $Tween
var hide :bool = true

func set_color(_color : Color):
	_message_3d.set_color(_color)
	
func set_message(_msg):
	_message_3d.set_message(_msg)

func _ready():
	hide()
	
func _process(delta):
	translation.y += 4.0 * delta
	
	if translation.y > 8.0:
		hide()
		return
	
func hide():
	hide = true
	set_process(not hide)
	visible = not hide
	
func show():
	hide = false
	set_process(not hide)
	visible = not hide
	_tween.interpolate_property(_message_3d,"modulate:a",1.0,0.0, 2.0,Tween.TRANS_SINE)
	_tween.start()
