extends Control

const item_template = preload("res://assets/ui/scoreboard/item/item.tscn")

onready var _scores :Array = []
onready var _holder = $VBoxContainer2/holder

func update_score(score :ScoreData):
	if score.player_id.empty():
		return
		
	if not _is_in_scores(score):
		_scores.append(score)
		
	for s in _scores:
		if not s is ScoreData:
			continue
			
		if s.player_id == score.player_id:
			s.kill_count += score.kill_count
			s.death_count += score.death_count
			break
			
	display_scoreboard()
	
func _is_in_scores(score :ScoreData) -> bool:
	for s in _scores:
		if not s is ScoreData:
			continue
			
		if score.player_id == s.player_id:
			return true
			
	return false
	
func display_scoreboard():
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
	
	
	
