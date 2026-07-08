package main

import "core:path/slashpath"
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

	STATE := start_state()

	players := generate_players()

	projectiles: [dynamic]Projectile
	enemy_projectiles: [dynamic]Projectile
	enemies: [dynamic]Enemy
	obstacles: [dynamic]Obstacle

	camera := generate_scene_camera()

	y_axis, _ := generate_obstacles(&obstacles)

	generate_enemies(&enemies, y_axis)

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
		update_enemies(&enemies, &enemy_projectiles, delta)

		// Draw
		rl.BeginDrawing()
		rl.ClearBackground(BACKGROUND)
		rl.BeginMode2D(camera)

		draw_entities(projectiles, enemy_projectiles, obstacles, enemies, players)

		rl.EndMode2D()
		draw_current_level(&STATE, translations.level)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
