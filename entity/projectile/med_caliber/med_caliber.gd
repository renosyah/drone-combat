extends BaseProjectile

func _ready():
	attack_damage = 70
	
func _on_med_caliber_body_entered(body):
	._on_projectile_body_entered(body)
