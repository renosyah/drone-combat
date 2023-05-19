extends HBoxContainer

export var credit_name :String
export var credit_details :Array

onready var _credit_name = $HBoxContainer/credit_name
onready var _credit_detail_template = $HBoxContainer/credit_detail_template
onready var _holder = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	_credit_name.text = credit_name
	for i in credit_details:
		var dup = _credit_detail_template.duplicate()
		dup.text = i
		dup.visible = true
		_holder.add_child(dup)
		
