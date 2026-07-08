package main

import localization "localization"
import rl "vendor:raylib"

WIDTH :: 800
HEIGHT :: 600
WINDOW :: "Invaders"
BACKGROUND :: rl.BLACK
MAX_PROJECTILES_ON_SCREEN :: 20
TARGET_FPS :: 60
BASE_SPACESHIP_SPEED :: 400

MAX_OBSTACLES_PER_ROW :: 42
MAX_ROWS :: 7

OBSTACLE_MARGIN :: 18

MAX_NUMBER_OF_ENEMIES :: 5
ENEMY_X_MARGIN :: 50

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, WINDOW)

	current_lang := localization.Locale.En
	translations := localization.load_translations(current_lang)

	rl.SetTargetFPS(TARGET_FPS)

	screen_width := f32(rl.GetScreenWidth())
	screen_height := f32(rl.GetScreenHeight())
	spaceship_width: f32 = 60.0
	bottom_margin: f32 = 70.0

	STATE := start_state()


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
		),
	)

	projectiles: [dynamic]Projectile
	enemy_projectiles: [dynamic]Projectile


	enemies: [dynamic]Enemy

	obstacles: [dynamic]Obstacle

	x_axis := 0
	y_axis := 0

	camera := rl.Camera2D {
		offset   = rl.Vector2{0.0, 0.0},
		target   = rl.Vector2{0.0, 0.0},
		rotation = 0.0,
		zoom     = 1.0,
	}

	for y_axis < MAX_ROWS {
		if x_axis > MAX_OBSTACLES_PER_ROW {
			x_axis = 0
			y_axis += 1
			continue
		}
		append(
			&obstacles,
			init_obstacle(
				f32((x_axis * OBSTACLE_MARGIN) + OBSTACLE_MARGIN),
				f32(y_axis * OBSTACLE_MARGIN) + OBSTACLE_MARGIN,
			),
		)
		x_axis += 1
	}

	j := 0
	for j < MAX_NUMBER_OF_ENEMIES {
		append(
			&enemies,
			init_enemy(
				f32(ENEMY_X_MARGIN * j) + ENEMY_X_MARGIN,
				OBSTACLE_MARGIN * f32(y_axis + 1),
			),
		)
		j += 1
	}

	for !rl.WindowShouldClose() {

		// Update
		delta := rl.GetFrameTime()
		for &pl in players {
			handle_spaceship_controls(&pl, &projectiles, delta)
		}

		if rl.IsKeyReleased(rl.KeyboardKey.O) {
			if current_lang == localization.Locale.En {
				current_lang = localization.Locale.Es
			} else {
				current_lang = localization.Locale.En
			}
			translations = localization.load_translations(current_lang)
		}

		update_and_mutate_projectiles(&projectiles, &enemies, &obstacles, delta)
		update_and_mutate_projectiles(&enemy_projectiles, &players, &obstacles, delta)

		ei := 0
		for ei < len(&enemies) {
			enemy := &enemies[ei]
			update_enemy(enemy, &enemies, &enemy_projectiles, ei, delta)
			if enemy.should_delete {
				unordered_remove(&enemies, ei)
				continue
			}
			ei += 1
		}

		// Draw
		rl.BeginDrawing()
		rl.ClearBackground(BACKGROUND)
		rl.BeginMode2D(camera)
		for pr in projectiles {
			rl.DrawRectangleRec(pr.collider, rl.RED)
		}
		for pr_e in enemy_projectiles {
			rl.DrawRectangleRec(pr_e.collider, rl.RED)
		}
		for ob in obstacles {
			rl.DrawRectangleRec(ob.collider, rl.BLUE)
		}
		for en in enemies {
			rl.DrawRectangleRec(en.collider, en.color)
		}
		for pl in players {
			rl.DrawRectangleRec(pl.collider, rl.BLUE)
		}
		rl.EndMode2D()
		draw_current_level(&STATE, translations.level)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
