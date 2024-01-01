--todo:

-- get chars walking again
-- colision detechtion
---- each player will need a smaller hitbox for collision detetion
-- hiding places overally

-- hook up mummy
-- hidden people (x, y on map)
-- list of hiding places for each player
---- randomly assigned when game begins
---- will need a list of x,y hiding places
---- assign the hiding
-- look action // when the look button is pressed, checks pixels around the player for a hidden sqare

-- score system
-- game over win /loose screen

function _init()
    state = 'title'
    score = 0
    looks = 5
    players = {}
    selected_plr = 'select player'
    selected = 0
    debug = true
    if state == 'title' then
        --title screen
        --player selection
        add(players, init_player('arla', 8, 0, 12, 16, 10, 90 - 16, 'title'))
        add(players, init_player('phoebe', 1, 16, 13, 14, 40, 90 - 14, 'title'))
        add(players, init_player('daddy', 56, 0, 17, 32, 70, 90 - 32, 'title'))
        add(players, init_player('mummy', 56, 0, 17, 32, 70, 90 - 32, 'title'))
    elseif state == 'play' then
        -- add the players
    elseif state == 'end' then
        -- if won or lost
        -- play again ?
    end
end

function _update()
    if state == 'title' then
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
    elseif state == 'end' then
        -- if won or lost
        -- play again ?
    end
    if debug then
        -- printh("state: " .. state , 'debug.log',false)
    end
end

function _draw()
    if state == 'title' then
        cls(9)
        print("hide", 128 / 2 - 8, 20, 12)
        print("n", 128 / 2 - 3, 30, 12)
        print("seek", 128 / 2 - 8, 40, 12)
        drawPlayers()
        selectedx = 128 / 2 - #selected_plr / 2 * 4
        print(selected_plr, selectedx, 100, 3)
        --title screen
        --player selection
    elseif state == 'play' then
        --title screen
        --player selection
        cls()
        map()
        drawPlayers()
        -- hiding places
        -- couch
        -- map(9, 4, 9 * 8, 4 * 8, 3, 6)

    elseif state == 'end' then
        -- if won or lost
        -- play again ?
    end
end

function drawPlayers()
    for p in all(players) do
        p:draw()
    end
end