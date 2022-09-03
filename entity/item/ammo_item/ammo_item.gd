extends BaseItem

var ammo_added :int = 60

func on_picked_up_by(body :BaseHull):
	body.resupply(ammo_added)
	.on_picked_up_by(body)
