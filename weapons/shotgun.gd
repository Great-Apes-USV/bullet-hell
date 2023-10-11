class_name Shotgun
extends Weapon

var spread_angle : float = 30
var bullet_count : int = 5

func spawn_bullets():
	for i in range(bullet_count):
		var bullet_rotation : float = lerp(spread_angle * 0.5, -spread_angle * 0.5, float(i) / (bullet_count - 1))
		var bullet = create_bullet()
		bullet.rotation += deg_to_rad(bullet_rotation)
		player.get_tree().root.add_child(bullet)
