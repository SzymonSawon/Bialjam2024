package truck

import "core:fmt"
import rl "vendor:raylib"

intro_scene :: proc(w: ^World, dt: f32) {
	rl.ClearBackground(rl.RAYWHITE)

	screen_size := rl.Vector2{auto_cast rl.GetRenderWidth(), auto_cast rl.GetRenderHeight()}

    w.intro_timer += dt

    if w.intro_timer < 3 {
        {
            message: cstring = "Interdimensional Foodtruck Simulator"
            width := rl.MeasureText(message, 30)
            rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 - 15, 30, rl.BLACK)
        }
        {
            message: cstring = "a game by Team Blue"
            width := rl.MeasureText(message, 20)
            rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 + 30, 20, rl.BLACK)
        }
    } else if w.intro_timer < 6 {
        {
            message: cstring = "created using"
            width := rl.MeasureText(message, 20)
            rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 - 40, 20, rl.BLACK)
        }
        rl.DrawText("&", auto_cast screen_size.x / 2 - 10, auto_cast screen_size.y / 2 + 50, 20, rl.BLACK)
        rl.DrawTextureEx(w.assets.odin_logo, screen_size / 2 - {300, 0}, 0, 0.5, rl.WHITE)
        rl.DrawTextureEx(w.assets.raylib_logo, screen_size / 2 + {50, 0}, 0, 1, rl.WHITE)
    } else if w.intro_timer < 10 {
        {
            message: cstring = "WARNING!!!"
            width := rl.MeasureText(message, 30)
            rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 - 15, 30, rl.BLACK)
        }
        {
            message: cstring = "This game contains heavily flashing images.\nBefore playing be sure to consult your doctor."
            width := rl.MeasureText(message, 20)
            rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 + 30, 20, rl.BLACK)
        }
    } else {
        world_set_scene(w, .MENU)
    }
}

menu_scene :: proc(w: ^World) {
	screen_size := rl.Vector2{auto_cast rl.GetRenderWidth(), auto_cast rl.GetRenderHeight()}

    rl.DrawRectangle(0,0,200, 100, rl.BLACK);
    {
        time := rl.GetTime()
        color := rl.ColorFromHSV(auto_cast (cast(i32) (time * 40) % 360), 0.8, 1)
        rl.DrawText("Interdimensional", 60, 30, 30, color);
        rl.DrawText("Foodtruck", 60, 65, 30, rl.WHITE);
        rl.DrawText("Simulator", 60, 100, 30, rl.WHITE);
    }

	if (gui_button({screen_size.x / 4, screen_size.y / 2 - 10}, "Play")) {
		world_set_scene(w, .GAMEPLAY)
	}
	if (gui_button({screen_size.x / 4, screen_size.y / 2 + 70}, "Quit")) {
		w.should_quit = true
	}

	rl.DrawText("Game by: Team Blue for Bialjam 2024", 10, auto_cast screen_size.y - 30, 20, rl.WHITE)
}

game_over_scene :: proc(w: ^World) {
	screen_size := rl.Vector2{auto_cast rl.GetRenderWidth(), auto_cast rl.GetRenderHeight()}

	rl.DrawRectangle(0, 0, rl.GetRenderWidth(), rl.GetRenderHeight(), rl.ColorAlpha(rl.RED, 0.5))
	{
		message: cstring = "Game over!"
		width := rl.MeasureText(message, 40)
		rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 - 100, 40, rl.WHITE)
	}

	{
		message:=rl.TextFormat("your score was: %d", cast(i32)w.score) 
		width := rl.MeasureText(message, 30)
		rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 - 50, 30, rl.WHITE)
	}

	{
		message:=rl.TextFormat("you survived %d rounds", w.round_number - 1) 
		width := rl.MeasureText(message, 30)
		rl.DrawText(message, auto_cast screen_size.x / 2 - width / 2, auto_cast screen_size.y / 2 - 20, 30, rl.WHITE)
	}

	if (gui_button({screen_size.x / 2 - 100, screen_size.y / 2 + 30}, "Restart")) {
        world_reload(w)
		world_set_scene(w, .GAMEPLAY)
	}
	if (gui_button({screen_size.x / 2 - 100, screen_size.y / 2 + 80}, "Menu")) {
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
