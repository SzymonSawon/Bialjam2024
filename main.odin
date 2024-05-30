package truck

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1600
HEIGHT :: 900
BACKGROUND :: rl.Color{0x18, 0x18, 0x18, 0xff}

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "InterdimensionalFoodTruck")
	defer rl.CloseWindow()

	rl.SetTargetFPS(120)
	rl.DisableCursor()

	world := World{}
	init_world(&world)

	fmt.printfln("%f", world)


	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()

		update_world(&world, rl.GetFrameTime())

		{
			rl.BeginMode3D(world.main_camera)
			defer rl.EndMode3D()

			rl.ClearBackground(BACKGROUND)
			rl.DrawGrid(10, 1)
		}
		rl.DrawFPS(10, 10)
	}
}
