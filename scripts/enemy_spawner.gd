extends Node2D


func spawn_all():
	for spawnpoint in get_children():
		spawn_enemy(spawnpoint.position)


func spawn_enemy(enemy_position: Vector2):
	var enemy = preload("res://characters/enemy.tscn").instantiate()
	enemy.position = enemy_position
	enemy.player = GameHandler.player
	GameHandler.enemies.add_child(enemy)
