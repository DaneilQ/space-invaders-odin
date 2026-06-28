package main

import rl "vendor:raylib"

WIDTH :: 800
HEIGHT :: 600
TITLE :: "Invaders test"
BACKGROUND :: rl.BLACK
MAX_PROJECTILES_ON_SCREEN :: 20
TARGET_FPS :: 60
BASE_SPACESHIP_SPEED :: 400

MAX_OBSTACLES_PER_ROW :: 42
MAX_ROWS :: 20


boostrap :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, TITLE)

	rl.SetTargetFPS(TARGET_FPS)

	screen_width := f32(rl.GetScreenWidth())
	screen_height := f32(rl.GetScreenHeight())
	spaceship_width: f32 = 60.0
	bottom_margin: f32 = 70.0

	spaceship := init_spaceship(
		rl_rectangle(
			get_half(screen_width) - get_half(spaceship_width),
			screen_height - bottom_margin,
			spaceship_width,
			30,
		),
		BASE_SPACESHIP_SPEED,
	)

	projectiles: [dynamic]Projectile

	obstacles: [dynamic]Obstacle

	x_axis := 0
	y_axis := 0

	for y_axis < MAX_ROWS {
		if x_axis > MAX_OBSTACLES_PER_ROW {
			x_axis = 0
			y_axis += 1
			continue
		}
		append(&obstacles, init_obstacle(f32((x_axis * 18) + 18), f32(y_axis * 18) + 18.0))
		x_axis += 1
	}

	for !rl.WindowShouldClose() {

		// Update
		delta := rl.GetFrameTime()
		move_spaceship(&spaceship, delta)

		if len(projectiles) <= MAX_PROJECTILES_ON_SCREEN {
			if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
				append(&projectiles, init_projectile(&spaceship))
			}
		}


		i := 0
		for i < len(projectiles) {
			pr := &projectiles[i]
			check_bounds(pr, HEIGHT)
			check_collisions_with_obstacles(pr, &obstacles)
			if pr.should_delete {
				unordered_remove(&projectiles, i); continue
			}
			update_projectile(pr, delta)
			i += 1
		}

		// Draw

		rl.BeginDrawing()
		rl.ClearBackground(BACKGROUND)
		for pr in projectiles {
			rl.DrawRectangleRec(pr.collider, rl.RED)
		}
		for ob in obstacles {
			rl.DrawRectangleRec(ob.collider, rl.BLUE)
		}
		rl.DrawRectangleRec(spaceship.collider, rl.BLUE)
		rl.DrawFPS(10, 10)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
