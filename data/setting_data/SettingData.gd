extends BaseData
class_name SettingData

export var is_sfx_mute :bool = false
export var is_joystick_fixed :bool = false

func from_dictionary(data : Dictionary):
	is_sfx_mute = data["is_sfx_mute"]
	is_joystick_fixed = data["is_joystick_fixed"]
	
func to_dictionary() -> Dictionary :
	var data = {}
	data["is_sfx_mute"] = is_sfx_mute
	data["is_joystick_fixed"] = is_joystick_fixed
	return data
	
