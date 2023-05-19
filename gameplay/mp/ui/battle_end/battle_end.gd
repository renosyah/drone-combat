extends Control

signal rematch
signal main_menu

const item_template = preload("res://assets/ui/scoreboard/item/item.tscn")

onready var _scores :Array = []
onready var _holder = $VBoxContainer2/holder
onready var _rematch_button = $VBoxContainer2/HBoxContainer3/rematch

func set_scores(scores :Array):
	_scores.clear()
	for score in scores:
		var score_data : ScoreData = ScoreData.new()
		score_data.from_dictionary(score)
		_scores.append(score_data)
	
func display_scoreboard():
	_scores.sort_custom(MyCustomSorter, "sort")
		
	for child in _holder.get_children():
		_holder.remove_child(child)
		
	for s in _scores:
		if not s is ScoreData:
			continue
			
		var score_data :ScoreData = s
		var item = item_template.instance()
		item.score_data = score_data
		_holder.add_child(item)
		
class MyCustomSorter:
	static func sort(a, b : ScoreData):
		if a.total > b.total:
			return true
		return false
		
	
func display_rematch(_show : bool):
	_rematch_button.visible = _show
	
func _on_main_menu_pressed():
	emit_signal("main_menu")
	
func _on_rematch_pressed():
	emit_signal("rematch")











