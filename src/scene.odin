package main
import rl "vendor:raylib"

Scene :: struct {
	players:            ^[dynamic]Spaceship,
	enemies:            ^[dynamic]Enemy,
	enemy_projectiles:  ^[dynamic]Projectile,
	player_projectiles: ^[dynamic]Projectile,
}


generate_players :: proc() -> [dynamic]Spaceship {
	screen_width := f32(rl.GetScreenWidth())
	screen_height := f32(rl.GetScreenHeight())
	spaceship_width: f32 = 60.0
	bottom_margin: f32 = 70.0
	players: [dynamic]Spaceship
	append(
		&players,
		init_spaceship(
			rl_rectangle(
				get_half(screen_width) - get_half(spaceship_width),
				screen_height - bottom_margin,
				spaceship_width,
				SPACESHIP_HEIGHT,
			),
			BASE_SPACESHIP_SPEED,
			rl.BLUE,
		),
	)
	return players
}

generate_scene_camera :: proc() -> rl.Camera2D {
	return rl.Camera2D {
		offset = rl.Vector2{0.0, 0.0},
		target = rl.Vector2{0.0, 0.0},
		rotation = 0.0,
		zoom = 1.0,
	}
}

generate_obstacles :: proc(obstacles: ^[dynamic]Obstacle) -> (int, int) {
	x_axis := 0
	y_axis := 0

	for y_axis < MAX_ROWS {
		if x_axis > MAX_OBSTACLES_PER_ROW {
			x_axis = 0
			y_axis += 1
			continue
		}
		append(
			obstacles,
			init_obstacle(
				f32((x_axis * OBSTACLE_MARGIN) + OBSTACLE_MARGIN),
				f32(y_axis * OBSTACLE_MARGIN) + OBSTACLE_MARGIN,
			),
		)
		x_axis += 1
	}

	return y_axis, x_axis
}

generate_enemies :: proc(enemies: ^[dynamic]Enemy, y_axis: int) {
	j := 0
	for j < MAX_NUMBER_OF_ENEMIES {
		append(
			enemies,
			init_enemy(
				f32(ENEMY_X_MARGIN * j) + ENEMY_X_MARGIN,
				OBSTACLE_MARGIN * f32(y_axis + 1),
			),
		)
		j += 1
	}
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
