package truck

import "core:fmt"
import rl "vendor:raylib"

menu_scene :: proc(w: ^World) {
	screen_size := rl.Vector2{auto_cast rl.GetRenderWidth(), auto_cast rl.GetRenderHeight()}

	if (gui_button({screen_size.x / 4, screen_size.y / 2 - 10}, "Play")) {
		world_set_scene(w, .GAMEPLAY)
	}
	if (gui_button({screen_size.x / 4, screen_size.y / 2 + 70}, "Quit")) {
		w.should_quit = true
	}

	rl.DrawText("Game by: [WIP] for Bialjam 2024", 10, auto_cast screen_size.y - 30, 20, rl.WHITE)
}

game_over_scene :: proc(w: ^World) {
	screen_size := rl.Vector2{auto_cast rl.GetRenderWidth(), auto_cast rl.GetRenderHeight()}

	rl.DrawRectangle(0, 0, rl.GetScreenWidth(), rl.GetScreenHeight(), rl.ColorAlpha(rl.RED, 0.5))
	{
		message: cstring = "Game over!"
		width := rl.MeasureText(message, 40)
		rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 - 100, 40, rl.WHITE)
	}

	rl.DrawRectangle(0, 0, rl.GetScreenWidth(), rl.GetScreenHeight(), rl.ColorAlpha(rl.RED, 0.5))
	{
		message:=rl.TextFormat("your score was: %d", cast(i32)w.score) 
		width := rl.MeasureText(message, 30)
		rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 - 50, 30, rl.WHITE)
	}

	if (gui_button({screen_size.x / 2 - 100, screen_size.y / 2}, "Restart")) {
        world_reload(w)
		world_set_scene(w, .GAMEPLAY)
	}
	if (gui_button({screen_size.x / 2 - 100, screen_size.y / 2 + 50}, "Menu")) {
        world_reload(w)
		world_set_scene(w, .MENU)
	}
}

gui_button :: proc(pos: rl.Vector2, capt: string) -> bool {
	message := rl.TextFormat("%s", capt)
	width := rl.MeasureText(message, 20)
	rect := rl.Rectangle{pos.x, pos.y, auto_cast width + 50, 40}
	if rl.CheckCollisionPointRec(rl.GetMousePosition(), rect) {
		rl.DrawRectangleRec(rect, rl.GRAY)
		rl.DrawText(message, auto_cast pos.x + 25, auto_cast pos.y + 5, 20, rl.BLACK)
		return rl.IsMouseButtonReleased(.LEFT)
	} else {
		rl.DrawText(message, auto_cast pos.x + 25, auto_cast pos.y + 5, 20, rl.WHITE)
	}
	rl.DrawLineV(pos + {0, 40}, pos + {auto_cast width + 50, 40}, rl.WHITE)
	return false
}
