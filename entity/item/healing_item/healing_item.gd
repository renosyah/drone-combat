extends BaseItem

var heal_hp :int = 80

func on_picked_up_by(body :BaseHull):
	body.heal(heal_hp)
	.on_picked_up_by(body)
