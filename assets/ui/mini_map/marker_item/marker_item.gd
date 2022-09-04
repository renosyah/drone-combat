extends Sprite
class_name MarkerItem

export var icon :Resource
export var color :Color

onready var _pivot = $pivot
onready var _marker_icon = $marker_icon
onready var _arrow_icon = $pivot/control/arrow_icon

func _ready():
	_marker_icon.texture = icon
	_marker_icon.modulate = color
	_arrow_icon.modulate = color

func look_at(at :Vector2):
	#.look_at(at)
	_pivot.look_at(at)
