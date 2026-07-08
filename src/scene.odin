package main


Scene :: struct {
	players:            ^[dynamic]Spaceship,
	enemies:            ^[dynamic]Enemy,
	enemy_projectiles:  ^[dynamic]Projectile,
	player_projectiles: ^[dynamic]Projectile,
}
