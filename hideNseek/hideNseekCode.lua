--todo:

-- end screens text in white and at bottom
-- continue circle animation on win or loose state
-- on loose, hiden players reveal themselves
-- daddy under table reveal is bad, needs to come out over carpet

-- get chars walking again
-- hook up mummy

-- players can't be hiden in the same place
-- sound effects

function _init(s)
    if s == nil then
        s = 'title'
    end
    state = s
    looks = 10
    players = {}
    selected_plr = 'select player'
    selected = 0
    debug = true
    add(
        players, init_player(
            'arla', 8, 0, 12, 16, 10, 90 - 16, {
                { x = 3, y = 17, toX = 18, toY = 17 },
                { x = 18, y = 0, toX = 18, toY = 17 },
                { x = 3, y = 62, toX = 18, toY = 62 },
                { x = 18, y = 98, toX = 18, toY = 77 },
                { x = 41, y = 98, toX = 41, toY = 77 },
                { x = 45, y = 55, toX = 45, toY = 74 },
                { x = 51, y = 38, toX = 66, toY = 38 },
                { x = 44, y = 25, toX = 44, toY = 7 },
                { x = 85, y = 1, toX = 85, toY = 15 },
                { x = 113, y = 49, toX = 113, toY = 30 },
                { x = 87, y = 55, toX = 67, toY = 55 },
                { x = 114, y = 84, toX = 97, toY = 84 }
            }
        )
    )
    add(
        players, init_player(
            'phoebe', 1, 16, 13, 14, 40, 90 - 14, {
                { x = 3, y = 17, toX = 18, toY = 17 },
                { x = 18, y = -2, toX = 18, toY = 17 },
                { x = 3, y = 62, toX = 18, toY = 62 },
                { x = 18, y = 98, toX = 18, toY = 77 },
                { x = 41, y = 98, toX = 41, toY = 77 },
                { x = 45, y = 55, toX = 45, toY = 74 },
                { x = 51, y = 38, toX = 66, toY = 38 },
                { x = 44, y = 25, toX = 44, toY = 7 },
                { x = 85, y = 1, toX = 85, toY = 15 },
                { x = 113, y = 49, toX = 113, toY = 30 },
                { x = 87, y = 55, toX = 67, toY = 55 },
                { x = 114, y = 84, toX = 97, toY = 84 }
            }
        )
    )

    add(
        players, init_player(
            'daddy', 56, 0, 17, 32, 70, 90 - 32, {
                -- daddy hiding places
                { x = 47, y = 24, toX = 63, toY = 24 },
                { x = 47, y = 41, toX = 47, toY = 24 },
                { x = 58, y = 97, toX = 58, toY = 62 },
                { x = 111, y = 78, toX = 95, toY = 78 },
                { x = 86, y = 39, toX = 104, toY = 39 },
                { x = 0, y = 32, toX = 16, toY = 32 }
            }
        )
    )

    -- add(players, init_player('mummy', 56, 0, 17, 32, 70, 90 - 32,{
    --     -- daddy hiding places
    --     { x = 47, y = 24, toX = 63, toY = 24 },
    --     { x = 47, y = 41, toX = 47, toY = 24 },
    --     { x = 58, y = 97, toX = 58, toY = 62 },
    --     { x = 111, y = 78, toX = 95, toY = 78 },
    --     { x = 86, y = 39, toX = 104, toY = 39 },
    --     { x = 1, y = 32, toX = 16, toY = 32 },
    -- }))
end

function _update()
    if state ==  'title' then
        --player selection
        if selected != 0 then
            if btnp(0) then
                selected -= 1
            end
            if btnp(1) then
                selected += 1
            end
            if selected < 1 then
                selected = #players
            end
            if selected > #players then
                selected = 1
            end
            for p in all(players) do
                p.state = "title"
            end
            players[selected].state = "title_selected"
            selected_plr = players[selected].name
            if btnp(4) or btnp(5) then
                -- set up game
                for i, p in pairs(players) do
                    if i == selected then
                        p:start("play")
                    else
                        p:start("hide")
                    end
                end
                state = "play"
            end
        else
            if btnp(0) or btnp(1) or btnp(4) or btnp(5) then
                selected = 1
            end
        end
    elseif state == 'play' then
        for p in all(players) do
            p:update()
        end
    elseif state == 'lost' or state == 'won' then
        if btnp(4) or btnp(5) then
            _init('title')
        end
    end
    if debug then
        -- printh("state: " .. state , 'debug.log',false)
    end
end

function _draw()
    if  state == 'title' then
        cls(9)
        print("hide", 128 / 2 - 8, 20, 12)
        print("n", 128 / 2 - 3, 30, 12)
        print("seek", 128 / 2 - 8, 40, 12)
        --player selection
        drawPlayers({ 'title', 'title_selected' })
        selectedx = 128 / 2 - #selected_plr / 2 * 4
        print(selected_plr, selectedx, 100, 3)
    elseif state == 'play' or state == 'won' or state == 'lost' then
        --title screen
        --player selection
        cls()
        -- draw the floor
        for y = 0, 120, 8 do
            for x = 0, 120, 8 do
                -- Access and modify pixels within the 8x8 block at (x, y) here
                map(16, 0, x, y)
            end
        end
        drawPlayers({ 'hide', 'reveal' })
        -- draw the furniture
        map()
        -- hiding places
        -- couch
        -- map(9, 4, 9 * 8, 4 * 8, 3, 6)

        drawPlayers({ 'found' })
        drawPlayers({ 'play', 'looking' })
        -- scores
        rectfill(0, 112, 127, 127, 9)
        print('looks left: ' .. looks, 5, 120, 7)
    end
    if state == 'lost' then
        print("sorry", 128 / 2 - 10, 20, 0)
        print("you lost", 128 / 2 - 16, 30, 0)
        print("try again?", 128 / 2 - 20, 40, 0)
    elseif state == 'won' then
        print("congratulations!", 128 / 2 - 32, 20,0)
        print("you won!", 128 / 2 - 16, 30, 0)
        print("play again?", 128 / 2 - 22, 40, 0)
    end
    -- if state != nil then
    --     printh("state= " .. state, 'debug.log', false)
    -- end
end

function drawPlayers(states)
    for p in all(players) do
        for state in all(states) do
            if p.state == state then
                p:draw()
            end
        end
    end
end