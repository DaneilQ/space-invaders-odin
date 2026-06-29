package main


TranslationType :: enum {
	EASE,
	LINEAR,
}

Tween :: struct {
	timer: Timer,
}

init_tween :: proc(duration: f32) -> Tween {
	return Tween{timer = init_timer(duration)}
}


animate_property :: proc(tween: ^Tween, property: $T, final_property_value: T, duration: f32) {
    
}

update_tween :: proc(tween: ^Tween, delta: f32) {
	update_timer(&tween.timer, delta)
}
