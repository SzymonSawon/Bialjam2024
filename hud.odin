package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

draw_3d_hud :: proc(w: ^World, dt: f32) {
	rl.BeginMode3D(w.hud_camera)
	defer rl.EndMode3D()

	rl.ClearBackground(rl.BLANK)

	{
		item_model := item_get_model(w, w.player.held_item)
		time_since_change := w.now - w.player.held_item_change_time
		change_offset := (1 - math.min(1, (time_since_change / 0.2))) * -0.5
		rl.DrawModel(item_model, {-0.5, -0.3 + change_offset, 0.5}, 2, rl.WHITE)
	}
}
