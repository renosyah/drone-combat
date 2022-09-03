extends StaticBody
class_name BaseMap

signal on_map_click(_pos)

export var max_stuff = 120
export var stuff_directory = "res://map/model/"

var _click_translation = Vector3.ZERO
var _input_detector : Node

var stuffs = []

func _ready():
	connect("input_event", self, "_on_input_event")
	
	var _detector = preload("res://assets/other/input_detection/input_detection.tscn").instance()
	add_child(_detector)
	_input_detector = _detector
	_input_detector.connect("any_gesture", self, "_on_inputDetection_any_gesture")
	
func generate_random_stuff_placement():
	var _models = _find_obj_paths()
	stuffs.clear()
	
	for i in range(max_stuff):
		var stuff = MapStuffData.new()
		stuff.mesh_scene = _models[rand_range(0,_models.size() - 1)]
		stuff.translation = get_rand_pos()
		stuffs.append(stuff.to_dictionary())
		
func spawn_random_stuff_placement():
	for data in stuffs:
		var stuff = MapStuffData.new()
		stuff.from_dictionary(data)
		var mesh = MeshInstance.new()
		mesh.mesh = load(stuff.mesh_scene)
		add_child(mesh)
		mesh.translation = stuff.translation
	
func _on_input_event(camera, event, position, normal, shape_idx):
	_click_translation = position
	_click_translation.y = 0
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		emit_signal("on_map_click", _click_translation)
		
	# if touch screen
	_input_detector.check_input(event)
	
func _on_inputDetection_any_gesture(sig ,event):
	if event is InputEventSingleScreenTap:
		emit_signal("on_map_click", _click_translation)
		
func get_rand_pos() -> Vector3:
	var angle := rand_range(0, TAU)
	var distance := rand_range(5, 45)
	var posv2 = polar2cartesian(distance, angle)
	var posv3 = global_transform.origin + Vector3(posv2.x, 0.0, posv2.y)
	posv3.y = 0.0
	return posv3
	
func _find_obj_paths() -> Array:
	var png_paths := []
	var dir_queue := [stuff_directory]
	var dir: Directory
	var file: String
	while file or not dir_queue.empty():
		if file:
			if dir.current_is_dir():
				dir_queue.append("%s/%s" % [dir.get_current_dir(), file])
				
			elif file.ends_with(".obj.import"):
				png_paths.append("%s/%s" % [dir.get_current_dir(), file.get_basename()])
				
		else:
			if dir:
				dir.list_dir_end()
				
			if dir_queue.empty():
				break
				
			dir = Directory.new()
			dir.open(dir_queue.pop_front())
			dir.list_dir_begin(true, true)
		
		file = dir.get_next()
	
	return png_paths
