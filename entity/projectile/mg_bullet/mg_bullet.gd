extends BaseProjectile

func _ready():
	attack_damage = 1
	
func _on_mg_bullet_body_entered(body):
	._on_projectile_body_entered(body)
