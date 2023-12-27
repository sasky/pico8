--todo:
-- do living room floor plan
-- hidden people (x, y on map)
---- will need a list of x,y hiding places
---- assign the hiding
-- look action // when the look button is pressed, checks pixels around the player for a hidden sqare
-- colision detechtion
---- will I need staking to get daddy through stuff

function plrInit(x)
    x.vx = 0
    x.vy = 0
    x.s = 2
    -- keeping track of the x pos to move the frame over
    x.pxf = x.px
    -- timer
    x.t = x.px
    return x
end

function plrWalk(plr)
    plr.t += plr.w / 2
    local max = plr.px + plr.w * 3

    if plr.t % (plr.w + plr.px) == 0 then
        plr.pxf += plr.w
    end
    if plr.pxf >= max then
        plr.pxf = plr.px
    end
    return plr
end

function _init()
    -- sspr(plr.px, plr.py, plr.w, plr.h, plr.x, plr.y, plr.w, ply.gro, plr.vx < 0)
    a = {
        -- constants
        -- pixel map
        name = 'arla',
        px = 8,
        py = 0,
        w = 12,
        h = 16,
        state = 'look',
        -- vars
        -- gro = 16, -- growth
        -- movement
        x = 0,
        y = 20
    }
    -- 1,14,28,42
    p = {
        -- constants
        -- pixel map
        name = 'phoebe',
        px = 0,
        py = 16,
        w = 14,
        h = 14,
        state = 'hide',
        popup = { 82, 0 },
        -- vars
        -- gro = 16, -- growth
        -- movement
        x = 82,
        y = 62
    }
    -- 16
    -- 56, 72, 88,104
    d = {
        -- constants
        -- pixel map
        name = 'daddy',
        px = 56,
        py = 0,
        w = 16,
        h = 32,
        state = 'hide',
        popup = { 0, -2 },
        -- vars
        -- gro = 16, -- growth
        -- movement
        x = 76,
        y = 32
    }
    plrs = {}
    add(plrs, a)
    add(plrs, p)
    add(plrs, d)
    for k, v in pairs(plrs) do
        plrs[k] = plrInit(v)
    end
    plrI = 1
    plr = plrs[plrI]
end

function canMove(x, y)
    -- grey floor color
    local c = pget(x, y)
    return c == 6 or c == 13
end

function _update()
    plr.vx = 0
    plr.vy = 0

    -- bounds
    -- check if
    -- movement
    if btn(0) then
        -- and canMove(p.x - 2, p.y) then
        -- left
        plr.vx = -plr.s
        plr = plrWalk(plr)
    end
    -- if btnp(1) then
    if btn(1) then
        -- and canMove(p.x + 12 + 2, p.y) then
        -- right
        plr.vx = plr.s
        plr = plrWalk(plr)
    end
    if btn(2) then
        -- and canMove(p.x, p.y - 2) then
        -- up
        plr.vy = -plr.s
        plr = plrWalk(plr)
    end
    if btn(3) then
        -- and canMove(p.x, p.y + 16 + 2) then
        -- down
        plr.vy = plr.s
        plr = plrWalk(plr)
    end
    if btnp(4) then
        -- change active player
        if plrI >= count(plrs) then plrI = 0 end

        plrI += 1
        plr = plrs[plrI]
    end

    if btnp(5) then
        for k, v in pairs(plrs) do
            if v.state == "hide" then v.state = "reveal" end
        end
    end
    -- do the revel animation
    for k, v in pairs(plrs) do
        if v.state == "reveal" then
            -- if v.popup[1] != nil then
            --     if v.x >= v.popup[1] then 
            --         v.state = 'found'
            --     else 
            --         v.vx = v.s
            --         plr = plrWalk(plr)
            --     end
            -- end
            if v.popup[2] != nil then
                -- v.y = 32, popup[2] =  -2
                -- if v.y <= v.popup[2] then 
                    -- v.state = 'found'
                -- else 
                    v.vy = -v.s
                    v = plrWalk(v)
                -- end
            end
        end
    end

    plr.x += plr.vx / plr.s
    plr.y += plr.vy / plr.s

end

function _draw()
    cls()
    map()
    -- debug stuff
    print("x: " .. plr.x, 0, 115, 4)
    -- print("vx: " .. plr.vx, 0, 122, 4)
    print("y: " .. plr.y, 25, 115, 4)
    -- print("vy: " .. plr.vy, 25, 122, 4)

    -- print("pxf: " .. plr.pxf, 60, 115, 6)
    -- print("py: " .. plr.py, 60, 122, 6)
    -- print("w: " .. plr.w, 90, 115, 6)
    -- print("h: " .. count(plrs), 90, 122, 6)
    print("state: " .. plrs[3].state, 50, 122, 6)
    for k, v in pairs(plrs) do
        sspr(v.pxf, v.py, v.w, v.h, v.x, v.y, v.w, v.h, v.vx < 0)
    end
    -- hiding places
    -- couch
    map(9, 4, 9 * 8, 4 * 8, 3, 6)
end