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

	if !w.slime_has_awakened {
	} else {
		if w.now - w.start_round_time < 2.5 {
			rl.DrawTextureEx(
				w.assets.bell_sprite,
				{
					20,
					auto_cast (cast(i32)screen_size.y -
						30 -
						w.assets.bell_sprite.height / PIXELIZE),
				},
				math.sin(w.now * 10) * 10,
				0.3,
				rl.Color {
					0xff,
					0xff,
					0xff,
					auto_cast (0xff * math.sin((w.now - w.start_round_time) / 2.5 * rl.PI)),
				},
			)
		}
		draw_timer(w, screen_size, (w.now - w.start_round_time) / w.max_round_time)
	}
	rl.DrawRectangleRounded(
		rl.Rectangle{auto_cast screen_size.x - 90, 20, 70, 30},
		0.2,
		3,
		rl.GetColor(0x3E2B19ff),
	)
	rl.DrawRectangleRounded(
		rl.Rectangle{auto_cast screen_size.x - 85, 25, 60, 20},
		0.2,
		3,
		rl.GetColor(0xE7E1CFff),
	)
	{
		text_width := rl.MeasureText(rl.TextFormat("%d", cast(i32)w.score), 10)
		rl.DrawText(
			rl.TextFormat("%d", cast(i32)w.score),
			cast(i32)screen_size.x - 80 + (50 - text_width),
			30,
			10,
			rl.BLACK,
		)
	}
}

draw_timer :: proc(w: ^World, screen_size: rl.Vector2, t: f32) {
    if w.round_number == 1 {
        return
    }
	rl.DrawTextureEx(w.assets.timer_sprite, {20, 20}, 0, 0.3, rl.WHITE)
	rl.DrawCircleV(
		{20, 20} +
		{auto_cast w.assets.timer_sprite.width, auto_cast w.assets.timer_sprite.height} * 0.15,
		auto_cast w.assets.timer_sprite.width * 0.08,
		rl.GetColor(0xE7E1CFff),
	)
	rl.DrawCircleSector(
		{20, 20} +
		{auto_cast w.assets.timer_sprite.width, auto_cast w.assets.timer_sprite.height} * 0.15,
		auto_cast w.assets.timer_sprite.width * 0.07,
		-90 + 360 * t,
		270,
		16,
		rl.RED,
	)
}
