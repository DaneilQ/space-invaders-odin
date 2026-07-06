package main


TranslationType :: enum {
	EASE,
	LINEAR,
}

Tween :: struct {
	timer: Timer,
}

init_tween :: proc(duration: f32) -> Tween {
	t := Tween {
		timer = init_timer(duration),
	}
	reset_tween(&t)
	return t
}

reset_tween :: proc(tween: ^Tween) {
	reset_timer(&tween.timer)
}

animate_property :: proc(tween: ^Tween, property: $T, final_property_value: T, duration: f32) {
	if timer_is_done(tween.timer) {
		return
	}
	update_timer(&tween.timer, delta)
}
