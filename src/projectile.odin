package main

import rl "vendor:raylib"

Projectile :: struct {
	using co:   Entity,
	momentum_x: f32,
	momentum_y: f32,
}

PROJECTILE_WIDTH: f32 : 10.0
PROJECTILE_Y_MARGIN :: 15
BASE_PROJECTILE_SPEED :: -300.0


init_projectile :: proc(
	spaceship: $T,
	momentum_y: f32 = BASE_PROJECTILE_SPEED,
	momentum_x: f32 = 0.0,
) -> Projectile {
	return Projectile {
		collider = rl_rectangle(
			spaceship.collider.x + get_half(spaceship.collider.width) - get_half(PROJECTILE_WIDTH),
			spaceship.collider.y + PROJECTILE_Y_MARGIN,
			PROJECTILE_WIDTH,
			PROJECTILE_WIDTH,
		),
		momentum_x = momentum_x,
		momentum_y = momentum_y,
		should_delete = false,
		color = rl.RED,
	}
}


update_projectile :: proc(projectile: ^Projectile, delta: f32) {
	projectile.collider.y += projectile.momentum_y * delta
	projectile.collider.x += projectile.momentum_x * delta
}

check_bounds :: proc(projectile: ^Projectile, w_height: i32) {
	if projectile.collider.y > f32(w_height) {
		projectile.should_delete = true
	} else if projectile.collider.y <= 0 {
		projectile.should_delete = true
	}
}

check_collisions_with_enemies :: proc(projectile: ^Projectile, enemies: ^[dynamic]$T) {
	i := 0
	for i < len(enemies) {
		en := &enemies[i]
		if rl.CheckCollisionRecs(projectile.collider, en.collider) {
			projectile.should_delete = true
			unordered_remove(enemies, i)
		}
		i += 1
	}
}

check_collisions_with_obstacles :: proc(projectile: ^Projectile, obstacles: ^[dynamic]Obstacle) {
	i := 0
	for i < len(obstacles) {
		ob := &obstacles[i]
		if rl.CheckCollisionRecs(projectile.collider, ob.collider) {
			projectile.should_delete = true
			unordered_remove(obstacles, i)
			break
		}
		i += 1
	}
}

update_and_mutate_projectiles :: proc(
	projectiles: ^[dynamic]Projectile,
	entities: ^[dynamic]$T,
	obstacles: ^[dynamic]Obstacle,
	delta: f32,
) {
	i := 0
	for i < len(projectiles) {
		pr := &projectiles[i]
		check_bounds(pr, HEIGHT)

		check_collisions_with_enemies(pr, entities)
		check_collisions_with_obstacles(pr, obstacles)

		if pr.should_delete {
			unordered_remove(projectiles, i); continue
		}

		update_projectile(pr, delta)
		i += 1
	}
}
