package main

import rl "vendor:raylib"

Projectile :: struct {
	collider:      rl.Rectangle,
	momentum_x:    f32,
	momentum_y:    f32,
	should_delete: bool,
}

PROJECTILE_WIDTH: f32 : 10.0
PROJECTILE_Y_MARGIN :: 15
BASE_PROJECTILE_SPEED :: -300.0


init_projectile :: proc(
	spaceship: ^Spaceship,
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
