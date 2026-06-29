package main

import localization "localization"
import rl "vendor:raylib"
draw_current_level :: proc(state: ^State, text: string) {
	rl.DrawText(get_current_level(state, text), 10, 10, 20, rl.BROWN)
}
