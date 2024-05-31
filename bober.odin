package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

update_bober :: proc(w: ^World, dt: f32) {
	bober: ^Entity = nil
	for &e in w.entities {
		if e.kind == .BOBER {
			bober = &e
			break
		}
	}
	assert(bober != nil)
	target: f32 = 5
	if w.bober_arrives_time < w.now {
		target = 0.9
		if w.now - w.bober_arrives_time < 1 && !rl.IsSoundPlaying(w.assets.bober_laugh_sound) {
			rl.PlaySound(w.assets.bober_laugh_sound)
		}
		if w.now - w.bober_arrives_time > 8 {
			w.bober_arrives_time = w.now + auto_cast rl.GetRandomValue(5, 8)
		}
	}
	bober.position.y = math.lerp(bober.position.y, target, dt)

	bober.position.x = math.sin(w.now * 2)
	bober.position.z = math.sin(w.now * 4) * 0.5
}
