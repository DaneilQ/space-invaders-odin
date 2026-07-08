package main


Scene :: struct {
	players:            ^[dynamic]Spaceship,
	enemies:            ^[dynamic]Enemy,
	enemy_projectiles:  ^[dynamic]Projectile,
	player_projectiles: ^[dynamic]Projectile,
}


draw_entities :: proc(
	projectiles: [dynamic]Projectile,
	enemy_projectiles: [dynamic]Projectile,
	obstacles: [dynamic]Obstacle,
	enemies: [dynamic]Enemy,
	players: [dynamic]Spaceship,
) {
	for pr in projectiles {
		draw_rect(pr)
	}
	for pr_e in enemy_projectiles {
		draw_rect(pr_e)
	}
	for ob in obstacles {
		draw_rect(ob)
	}
	for en in enemies {
		draw_rect(en)
	}
	for pl in players {
		draw_rect(pl)
	}
}
