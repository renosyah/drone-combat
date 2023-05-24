extends Control

const item_template = preload("res://assets/ui/scoreboard/item/item.tscn")

onready var _scores :Array = []
onready var _holder = $SafeArea/VBoxContainer2/holder
	
func update_scoreboard(player_id, kill, death :int, _color :Color = Color.white, player_name :String = "", player_team : int = 0):
	var score :ScoreData = ScoreData.new()
	score.player_color = _color
	score.player_id = player_id
	score.player_name = player_name
	score.player_team = player_team
	score.kill_count = kill
	score.death_count = death
	update_score(score)
	
func update_score(score :ScoreData):
	if score.player_id.empty():
		return
		
	if not _is_in_scores(score):
		_scores.append(score)
		
	for _s in _scores:
		if not _s is ScoreData:
			continue
			
		var s :ScoreData = _s
		
		if s.player_id == score.player_id:
			s.kill_count += score.kill_count
			s.death_count += score.death_count
			s.total = s.get_total()
			break
			
	display_scoreboard()
	
func _is_in_scores(score :ScoreData) -> bool:
	for s in _scores:
		if not s is ScoreData:
			continue
			
		if score.player_id == s.player_id:
			return true
			
	return false
	
func set_scores(scores :Array):
	_scores.clear()
	for score in scores:
		var score_data : ScoreData = ScoreData.new()
		score_data.from_dictionary(score)
		_scores.append(score_data)
	
func get_scores() -> Array:
	var scores = []
	for score in _scores:
		scores.append(score.to_dictionary())
		
	return scores
	
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
	
func _on_resume_pressed():
	visible = false
	
class MyCustomSorter:
	static func sort(a, b : ScoreData):
		if a.total > b.total:
			return true
		return false
		
	
