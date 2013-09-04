require "level_maker"
require "level_decorator"
require "music"
require "ui"
function love.load()
	menu_offset = 128
	lvl = 1
	makeLevel(lvl)
end

function love.draw()
	-- Draw Map --
		-- Draw the map in its new location
  love.graphics.translate(map.x, map.y)
  map.map:autoDrawRange(map.x, map.y, 0, pad)
	map.map:draw()
	-- End Draw Map
	
	drawMenu()

	-- Draw Debug --
	--love.graphics.print("FPS: "..FPS, map.x * - 1, map.y * -1 + menu_offset)
	love.graphics.print("Tile: "..map.current_tile_x.." - "..map.current_tile_y,  menu.x, menu.y + menu.background:getHeight())
	--love.graphics.print("Mapy: "..menu.y, map.x * - 1, map.y * -1 + menu_offset)
	-- End Draw Debug --
end

function love.keypressed(key, unicode)
	if key == "up" or key == "down" or key == "left" or key == "right" then
		move_rooms(key)
	end
	if key == "q" or key == "escape" then
		os.exit()
	end
	if key == "1" then
		lvl = lvl + 1
		makeLevel(lvl)
	end
	if key == "2" then
		lvl = lvl - 1
		makeLevel(lvl)
	end
	if key == "`" then
		love.audio.play(music)
	end
	if key == "o" then
		drawMinimapRoom("all rooms")
	end
	if key == "m" then
		if menu.moving == "down" then
			menu.moving = "up"
		else
			menu.moving = "down"
		end
	end
end

function love.update(dt)
	FPS = love.timer.getFPS()
	
	map.x = map.x - ((map.x - map.going_x) * dt * 15)
	map.y = map.y - ((map.y - map.going_y) * dt * 20)
	menu.x = (map.x * - 1)
	menu.y = round((map.y * -1) - menu.background:getHeight() +  menu_offset +  menu.going_y)
	
	updateMinimappos()
end

