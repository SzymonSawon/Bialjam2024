package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

draw_3d_hud :: proc(w: ^World, dt: f32) {
	rl.ClearBackground(rl.BLANK)

	{
		rl.BeginMode3D(w.hud_camera)
		defer rl.EndMode3D()


		{
			item_model := item_get_model(w, w.player.held_item)
			time_since_change := w.now - w.player.held_item_change_time
			change_offset := (1 - math.min(1, (time_since_change / 0.2))) * -0.5
			rl.DrawModel(item_model, {-0.5, -0.3 + change_offset, 0.5}, 2, rl.WHITE)
		}
	}

	screen_size :=
		rl.Vector2{auto_cast rl.GetRenderWidth(), auto_cast rl.GetRenderHeight()} / PIXELIZE

	w.cursor_radius_t = 5 if w.targetted_entity != nil else 1
	w.cursor_radius = math.lerp(w.cursor_radius, w.cursor_radius_t, 10 * dt)

	rl.DrawCircleLinesV(screen_size / 2, w.cursor_radius + 1, rl.WHITE)
	rl.DrawCircleLinesV(screen_size / 2, w.cursor_radius, rl.BLACK)

	if w.player.held_item != .NONE {
        message := rl.TextFormat("holding: %s", item_get_name(w.player.held_item))
		rl.DrawText(
			message,
			auto_cast (screen_size.x * 0.5 + 21),
			auto_cast (screen_size.y * 0.5 + 21),
			10,
			rl.PURPLE,
		)
		rl.DrawText(
			message,
			auto_cast (screen_size.x * 0.5 + 20),
			auto_cast (screen_size.y * 0.5 + 20),
			10,
			rl.GREEN,
		)
	}
    rl.DrawText(
        rl.TextFormat("Time left: %f", w.max_round_time - (w.now - w.start_round_time)),
        auto_cast (screen_size.x - 100),
        auto_cast (screen_size.y - 20),
        10,
        rl.RED,
    )
}
