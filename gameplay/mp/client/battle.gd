extends BattleMp

func _ready():
	$player1.set_network_master(Network.PLAYER_HOST_ID)
	$player2.set_network_master(Network.PLAYER_HOST_ID)
	$player3.set_network_master(Network.PLAYER_HOST_ID)
