extends Control

onready var _animation = $SafeArea/Container/AnimationPlayer
onready var _item = $SafeArea/Container/TextureRect
onready var _title = $SafeArea/Container/VBoxContainer2/title

var item_unlocked :Resource
var title :String

func show_unlocked_item():
	visible = true
	_item.texture = item_unlocked
	_title.text = title
	_animation.play("unlocked")
	
func _on_continue_pressed():
	visible = false
