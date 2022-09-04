extends MarginContainer
class_name MiniMap

const DIMESION_MULTIPLIER = 120.0

var zoom = 2.5 # Scale multiplier.

# Node references.
var camera : GameplayCamera
onready var grid = $MarginContainer/Grid
onready var camera_marker = $MarginContainer/Grid/Camera
onready var object_marker_template = $MarginContainer/Grid/objectMarker

var map_objects = []
var grid_scale  # Calculated world to map scale.
var markers = {}  # Dictionary of object: marker.


func _ready():
	camera_marker.rect_position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	
func set_camera(_camera):
	camera = _camera
	camera.connect("on_camera_moving", self, "_on_camera_moving")

func _process(_delta):
	# If no player is assigned, do nothing.
	if !camera:
		return
		
	grid_scale = grid.rect_size / (get_viewport_rect().size * clamp(zoom , 0.5, 5))
	
	var cam_pos = grid_scale + grid.rect_size / 2
	cam_pos.x = clamp(cam_pos.x, 0, grid.rect_size.x)
	cam_pos.y = clamp(cam_pos.y, 0, grid.rect_size.y)
	
	camera_marker.rect_position = cam_pos
	
	for item in markers.keys():
		if is_instance_valid(item):
			var obj_pos = (Vector2(item.translation.x,item.translation.z) * DIMESION_MULTIPLIER - Vector2(camera.translation.x,camera.translation.z) * DIMESION_MULTIPLIER) * grid_scale + grid.rect_size / 2
			if grid.get_rect().has_point(obj_pos + grid.rect_position):
				markers[item].hide()
				
			else:
				markers[item].modulate.a = 0.8
				markers[item].show()
				
			# Don't draw markers outside grid rectangle.
			obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
			obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
			markers[item].position = obj_pos
			markers[item].look_at(camera_marker.rect_global_position) 
			
		else:
			remove_object(item)
		
func add_object(object :Spatial, marker_icon:Resource, marker_color :Color):
	var new_marker :MarkerItem = object_marker_template.duplicate()
	new_marker.icon = marker_icon
	new_marker.color = marker_color
	grid.add_child(new_marker)
	grid.move_child(new_marker, 0)
	new_marker.show()
	markers[object] = new_marker
	
func remove_object(object):
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)
		
		
func set_zoom(value):
	zoom = value
	grid_scale = grid.rect_size / (get_viewport_rect().size * clamp(zoom , 0.5, 5))
	
func _on_camera_moving( _pos, _zoom):
	set_zoom(_zoom + 1.5 * 2)
	camera_marker.rect_scale = Vector2.ONE * (_zoom + 0.5)
