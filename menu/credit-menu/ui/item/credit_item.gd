extends VBoxContainer

export var credit_name :String
export var credit_details :Array

onready var _credit_name = $credit_name
onready var _credit_detail_template = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	_credit_name.text = credit_name
	for i in credit_details:
		var dup = _credit_detail_template.duplicate()
		dup.get_child(1).text = i
		dup.visible = true
		add_child(dup)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_position.y -= 50 * delta
	if rect_position.y < -100:
		set_process(false)
		queue_free()
