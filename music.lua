--sound = love.audio.newSource("pling.wav", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
music = love.audio.newSource("music/dungeon.mp3", "stream") -- if "static" is omitted, LÖVE will stream the file from disk, good for longer music tracks
music:setLooping(true)
