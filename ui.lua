-- Load Menu --
menu = {}
menu.x = 0
menu.y = 0
menu.going_y = 0
menu.moving = "up"

menu.background = love.graphics.newImage("/sprites/ui/menubackground.png")
minimap_background = love.graphics.newImage("/sprites/ui/minimap_background.png")
minimap_room_visited = love.graphics.newImage("/sprites/ui/minimap_room_visited.png")
minimap_room_not_visited = love.graphics.newImage("/sprites/ui/minimap_room_not_visited.png")
minimap_current_room = love.graphics.newImage("/sprites/ui/minimap_current_room.png")
level_title = love.graphics.newImage("/sprites/ui/level_title.png")
level_numbers_img = love.graphics.newImage("/sprites/ui/level_numbers.png")
level_numbers = {}
for i = 1, 11, 1 do
	level_numbers[i] = love.graphics.newQuad(((i -1) * 12), 0, 12, 12, 120, 12)
end
red_box_img = love.graphics.newImage("/sprites/ui/red_box.png")
yellow_box_img = love.graphics.newImage("/sprites/ui/yellow_box.png")
bomb_icon_img = love.graphics.newImage("/sprites/ui/bomb_icon.png")
rupee_icon_img = love.graphics.newImage("/sprites/ui/rupee_icon.png")
key_icon_img = love.graphics.newImage("/sprites/ui/key_icon.png")
life_title = love.graphics.newImage("/sprites/ui/life_title.png")
empty_heart_img = love.graphics.newImage("/sprites/ui/empty_heart.png")
half_heart_img = love.graphics.newImage("/sprites/ui/half_heart.png")
full_heart_img = love.graphics.newImage("/sprites/ui/full_heart.png")
	-- End Load Menu --
	
function drawMenu()
	-- Draw Menu --
	love.graphics.draw(menu.background, menu.x, menu.y)
	love.graphics.draw(minimap_background, menu.x + 20 , menu.y + menu.background:getHeight() - minimap_background:getHeight() - 20)
	drawMinimapRoom(map.minimaprooms)
	
	-- Draw level indicator --
	love.graphics.draw(level_title, menu.x + 56 , menu.y + menu.background:getHeight() - minimap_background:getHeight() - 20)
	if lvl < 10 then
		love.graphics.drawq(level_numbers_img, level_numbers[lvl], menu.x + 130, menu.y + menu.background:getHeight() - minimap_background:getHeight() - 20)
	else
		level_num1 = math.floor(lvl/10)
		level_num2 = math.floor(lvl - (10 * level_num1))
		if level_num2 == 0 then
			level_num2 = 10
		end

		love.graphics.drawq(level_numbers_img, level_numbers[level_num1], menu.x + 124, menu.y + menu.background:getHeight() - minimap_background:getHeight() - 32)
		love.graphics.drawq(level_numbers_img, level_numbers[level_num2], menu.x + 136, menu.y + menu.background:getHeight() - minimap_background:getHeight() - 32)
	end
	-- End Draw level indicator

	love.graphics.draw(yellow_box_img, menu.x + 246 , menu.y + menu.background:getHeight() - yellow_box_img:getHeight() - 35)
	love.graphics.draw(red_box_img, menu.x + 294 , menu.y + menu.background:getHeight() - red_box_img:getHeight() - 35)
	love.graphics.draw(rupee_icon_img, menu.x + 180 , menu.y + menu.background:getHeight() - rupee_icon_img:getHeight() - 80)
	love.graphics.draw(key_icon_img, menu.x + 180 , menu.y + menu.background:getHeight() - key_icon_img:getHeight() - 48)
	love.graphics.draw(bomb_icon_img, menu.x + 180 , menu.y + menu.background:getHeight() - bomb_icon_img:getHeight() - 32)
	love.graphics.draw(life_title, menu.x + 400 , menu.y + menu.background:getHeight() - life_title:getHeight() - 90)
	
	--for i = 1, #player.total_hearts, 1 do
	--for testing
	total_hearts = 15
	health = 1
	local heart_x = 0
	local heart_y = 0
	for i = 1, total_hearts, 1 do
		-- How are we storing health. 2 points per heart?
		heart_x = heart_x + 1
		if i%11 == 0 then
			heart_y = heart_y + 1
			heart_x = 1
		end
		if health >= (i * 2) then
			-- Draw a full heart
			love.graphics.draw(full_heart_img, menu.x + 335 + (heart_x * 16) , menu.y + menu.background:getHeight() - full_heart_img:getHeight() - 70 + (heart_y * 16))
		end
		if health < (i * 2) then
			-- Draw an empty heart
			love.graphics.draw(empty_heart_img, menu.x + 335 + (heart_x * 16), menu.y + menu.background:getHeight() - empty_heart_img:getHeight() - 70 + (heart_y * 16))
		end
		if health == ((i * 2) -1) then
			-- Draw a half heart
			love.graphics.draw(half_heart_img, menu.x + 335 + (heart_x * 16), menu.y + menu.background:getHeight() - half_heart_img:getHeight() - 70 + (heart_y * 16))
		end
		
	end
	
	-- End Draw Menu --
end
	
function updateMinimappos(dt)
	-- Once the map has stopped, update the current tile were on.
	if round(map.x) == map.going_x and round(map.y) == map.going_y then
		map.current_tile_x = round(((map.x / 512) * -1) + 1) -- Keep the plus one dummy. There is no 0,0 tile.
		map.current_tile_y = round((((map.y - menu_offset)/ 352) * -1) + 1)
		-- look in the map.minimaprooms and don;t add it if its is already in there.
		-- IF YOU HAVE THE CURSE OF DARKNESS THEN DONT ADD THE LOCATION --
		-- IF YOU HAVE THE REVEALING BUFF THEN ADD HIDDEN ROOMS
			-- Check North
		if map.level[map.current_tile_y - 1] and map.level[map.current_tile_y - 1][map.current_tile_x] then
			if map.level[map.current_tile_y - 1][map.current_tile_x] ~= "." and map.level[map.current_tile_y - 1][map.current_tile_x] ~= "h" and map.level[map.current_tile_y - 1][map.current_tile_x] ~= "H" then
				if map.minimaprooms[map.current_tile_y - 1][map.current_tile_x] == "1" then
					map.minimaprooms[map.current_tile_y - 1][map.current_tile_x] = "2" -- 2 means 'seen'
				end
			end
		end
		-- Check South
		if map.level[map.current_tile_y + 1] and map.level[map.current_tile_y + 1][map.current_tile_x] then
			if map.level[map.current_tile_y + 1][map.current_tile_x] ~= "." and map.level[map.current_tile_y + 1][map.current_tile_x] ~= "h" and map.level[map.current_tile_y + 1][map.current_tile_x] ~= "H" then
				if map.minimaprooms[map.current_tile_y + 1][map.current_tile_x] == "1" then
					map.minimaprooms[map.current_tile_y + 1][map.current_tile_x] = "2" -- 2 means 'seen'
				end
			end
		end
		-- Check West
		if map.level[map.current_tile_y] and map.level[map.current_tile_y][map.current_tile_x - 1] then
			if map.level[map.current_tile_y][map.current_tile_x - 1] ~= "." and map.level[map.current_tile_y][map.current_tile_x - 1] ~= "h" and map.level[map.current_tile_y][map.current_tile_x - 1] ~= "H" then
				if map.minimaprooms[map.current_tile_y][map.current_tile_x - 1] == "1" then
					map.minimaprooms[map.current_tile_y][map.current_tile_x - 1] = "2" -- 2 means 'seen'
				end
			end
		end
		-- Check East
		if map.level[map.current_tile_y] and map.level[map.current_tile_y][map.current_tile_x + 1] then
			if map.level[map.current_tile_y][map.current_tile_x + 1] ~= "." and map.level[map.current_tile_y][map.current_tile_x + 1] ~= "h" and map.level[map.current_tile_y][map.current_tile_x + 1] ~= "H" then
				if map.minimaprooms[map.current_tile_y][map.current_tile_x + 1] == "1" then
					map.minimaprooms[map.current_tile_y][map.current_tile_x + 1] = "2" -- 2 means 'seen'
				end
			end
		end
		--This will error out if we go negative on the map, it wont happen when your paying the game
		map.minimaprooms[map.current_tile_y][map.current_tile_x] = "3" -- 2 means 'visited'
	end
	-- Move the menu if its needed
	if menu.moving == "up" then
		if menu.going_y ~= 0 then
			menu.going_y = menu.going_y - 1
		end
	end
	if menu.moving == "down" then
		if menu.going_y ~= 352 then
			menu.going_y = menu.going_y + 1
		end
	end
	-- End move menu
end

function drawMinimapRoom(newloc)
	if newloc[1] then
		for i = 1, #newloc, 1 do
			for e = 1, #newloc[1] do
				if newloc[i][e] == "2" then
					love.graphics.draw(minimap_room_not_visited, (menu.x + 18 + (16 * e)), (menu.y + menu.background:getHeight() - minimap_background:getHeight() - 12 + (8 * i)))
				end
				if newloc[i][e] == "3" then
					love.graphics.draw(minimap_room_visited, (menu.x + 18 + (16 * e)), (menu.y + menu.background:getHeight() - minimap_background:getHeight() - 12 + (8 * i)))
				end
			end
		end
		love.graphics.draw(minimap_current_room, (menu.x + 22 + (16 * map.current_tile_x)), (menu.y + menu.background:getHeight() - minimap_background:getHeight() - 12 + (8 * map.current_tile_y)))
	end
	
	if newloc == "all rooms" then
		for i = 1, #map.level, 1 do
			for e = 1, #map.level[1] do
				if map.level[i][e] ~= "." then -- "h" OR SECRECT HIDDEN ROOM
					map.minimaprooms[i][e] = "2"
				end
			end
		end
	end
end

function round(num)
    under = math.floor(num)
    upper = math.floor(num) + 1
    underV = -(under - num)
    upperV = upper - num
    if (upperV > underV) then
        return under
    else
        return upper
    end
end
function tableinTable(tbl, othertbl)
	for key, value in pairs(tbl) do
		if value[1] == othertbl[1] and value[2] == othertbl[2] then
			return true
		end
	end
	return false
end