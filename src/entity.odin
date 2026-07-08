package main

import rl "vendor:raylib"

Entity :: struct {
	collider:      rl.Rectangle,
	color:         rl.Color,
	should_delete: bool,
}


draw_rect :: proc(collider: Entity) {
	rl.DrawRectangleRec(collider.collider, collider.color)
}
