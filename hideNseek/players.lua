-- hidingPlaces = {
--     -- daddy hiding places
--     { x = 47, y = 24, toX = 63, toY = 24 },
--     { x = 47, y = 41, toX = 47, toY = 24 },
--     { x = 58, y = 97, toX = 58, toY = 62 },
--     { x = 111, y = 78, toX = 95, toY = 78 },
--     { x = 86, y = 39, toX = 104, toY = 39 },
--     { x = 1, y = 32, toX = 16, toY = 32 },
-- }
function init_player(name, px, py, w, h, x, y, hidingPlaces, s)
    s = s or 1

    return {
        -- constants
        name = name,
        hidingPlaces = hidingPlaces,
        -- pixel map
        px = px,
        py = py,
        w = w,
        h = h,
        -- state
        state = 'title',
        -- move state vars
        x = x,
        y = y,

        vx = 0,
        vy = 0,
        s = s,
        -- keeping track of the x pos to move the frame over
        pxf = px,
        -- timer
        t = px,
        -- look circle raduis
        cr = 4,
        -- hiding place index
        hidingPlace = {},
        update = function(self)
            self.vx = 0
            self.vy = 0
            local oldx = self.x
            local oldy = self.y
            local overrideBounds = false
            -- printh("player update: " .. self.state, 'debug.log', false)

            -- bounds
            -- check if
            -- movement
            -- Active states
            if self.state == 'play' then
                if btn(0) then
                    -- left
                    self.vx = -self.s
                    -- self:walk()
                elseif btn(1) then
                    -- and canMove(p.x + 12 + 2, p.y) then
                    -- right
                    self.vx = self.s
                    -- self:walk()
                elseif btn(2) then
                    -- and canMove(p.x, p.y - 2) then
                    -- up
                    self.vy = -self.s
                    -- self:walk()
                elseif btn(3) then
                    -- and canMove(p.x, p.y + 16 + 2) then
                    -- down
                    self.vy = self.s
                    -- self:walk()
                end

                if btnp(5) then
                    self:look()
                end
            elseif self.state == 'looking' then
                self.cr += self.s
                if self.cr > 14 then
                    for p in all(players) do
                        if p.state == "hide" then
                            p:found(self:getBox())
                        end
                    end
                    self.state = 'play'
                    self.cr = 4
                end
                -- Hiding States
            elseif self.state == "reveal" then
                -- todo, step though the reveal animation
                -- --     { x = 58, y = 97, toX = 58, toY = 62 },
                overrideBounds = true
                if self.hidingPlace.x < self.hidingPlace.toX then
                    self.vx = self.s
                end
                if self.hidingPlace.x > self.hidingPlace.toX then
                    self.vx = -self.s
                end
                if self.hidingPlace.y < self.hidingPlace.toY then
                    self.vy = self.s
                end
                if self.hidingPlace.y > self.hidingPlace.toY then
                    self.vy = -self.s
                end
                if self.hidingPlace.toX == self.x and self.hidingPlace.toY == self.y then
                    looks += 3
                    self.state = 'found'
                    -- check if the player has won the game
                    local playersFound = 0
                    for p in all(players) do
                        if p.state == "found" then
                            playersFound+= 1
                        end
                    end
                    -- -1 is the active player, so checking if all hidden players have been found
                    if playersFound >= #players -1 then
                        _init('won')
                    end

                end
            elseif self.state == "found" then
                -- just stand there, maybe follow the active player
                -- once I watch that AI course
            elseif self.state == "hide" then
                -- just hide I think
            elseif self.state == "title" then
                -- just hide I think
            end
            self.x += self.vx
            self.y += self.vy
            if not overrideBounds then
                if not self:canMove(oldx, oldy) then
                    self.x = oldx
                    self.y = oldy
                end
            end
        end,
        -- all states public functions
        draw = function(self)
            sspr(self.pxf, self.py, self.w, self.h, self.x, self.y, self.w, self.h, self.vx < 0)
            if (self.state == "title_selected") rect(self.x - 2, self.y - 2, self.x + self.w + 2, self.y + self.h + 2, 3)
            if (self.state == 'looking') circ(self.x + self.w / 2, self.y + self.h / 4, self.cr, 8)
            --
            -- show hitbox for moving
            -- local hitbox = self:getHitBox()
            -- rect(hitbox.x0, hitbox.y0, hitbox.x1, hitbox.y1, 6)
            --
            -- show border box
            -- local borderBox = self:getBox()
            -- rect(borderBox.x, borderBox.y, borderBox.xw, borderBox.yh, 8)
        end,
        start = function(self, state)
            if state == 'play' then
                self.x = 18
                self.y = 20
            elseif state == 'hide' then
                ---- then assign the player to a random
                ----  hiding place (from provided hiding places)
                -- printh("hiding player count: " .. #self.hidingPlaces, 'debug.log', false)
                self.hidingPlace = rnd(self.hidingPlaces)
                self.x = self.hidingPlace.x
                self.y = self.hidingPlace.y
            end
            self.state = state
        end,
        -- all states private functions
        getCenter = function(self)
            return { x = self.x + self.w / 2, y = self.y + self.h / 2 }
        end,
        getBox = function(self)
            local border = 3
            return {
                x = self.x - border,
                xw = self.x + self.w + border,
                y = self.y - border,
                yh = self.y + self.h + border
            }
        end,
        -- getBorderBox = function(self)
        --     -- x, y for each corner and mid points
        --     return {
        --         { x = self.x, y = self.y }, --top left
        --         { x = self.x + flr(self.w / 2), y = self.y }, --top middle
        --         { x = self.x + self.w, y = self.y }, -- top right
        --         { x = self.x + self.w, y = flr(self.y / 2) }, -- middle right
        --         { x = self.x + self.w, y = self.y + self.h }, -- bottom right
        --         { x = self.x + flr(self.w / 2), y = self.y + flr(self.h / 2) }, -- middle bottom
        --         { x = self.x, y = self.y + self.h }, -- bottom left
        --         { x = self.x, y = self.y + flr(self.h / 2) } -- middle left
        --     }
        -- end,
        -- active player public functions
        -- active player private functions
        walk = function(self)
            if self.state == 'play' then
                self.t += self.w / 2
                local max = self.px + self.w * 3

                if self.t % (self.w + self.px) == 0 then
                    self.pxf += self.w
                end
                if self.pxf >= max then
                    self.pxf = self.px
                    -- self.t =  self.px
                end
            end
        end,
        look = function(self)
            -- todo, do look circle animation
            self.state = 'looking'
            looks -= 1
            if looks < 1 then
                looks = 0
                _init('lost')
            end
            -- printh("x= " .. self.x .. ", y= " .. self.y, 'debug.log', false)
        end,
        getHitBox = function(self)
            -- draw a rect at bottom centre of the player sprite
            return {
                x0 = self.x + flr(self.w / 2) - 3,
                y0 = self.y + self.h - 6,
                x1 = self.x + flr(self.w / 2) + 4,
                y1 = self.y + self.h
            }
        end,
        canMove = function(self, oldx, oldy)
            -- only calculate if the delta has changed
            if oldx ~= self.x or oldy ~= self.y then
                -- the tiles you can walk on are marked with the 1 flag
                local b = self:getHitBox()
                local tl = fget(mget(b.x0 / 8, b.y0 / 8), 1)
                local tr = fget(mget(b.x1 / 8, b.y0 / 8), 1)
                local bl = fget(mget(b.x0 / 8, b.y1 / 8), 1)
                local br = fget(mget(b.x1 / 8, b.y1 / 8), 1)

                return tl and tr and bl and br
            end
            return true
        end,
        -- hidden player public functions
        -- hidden player private functions
        found = function(self, cmpBorderBox)
            local selfBorderBox = self:getBox()

            local isTouching = cmpBorderBox.x < selfBorderBox.xw
                    and cmpBorderBox.xw > selfBorderBox.x
                    and cmpBorderBox.y < selfBorderBox.yh
                    and cmpBorderBox.yh > selfBorderBox.y

            -- printh("is touching : " .. self.name .. " " .. tostr(isTouching), 'debug.log', false)
            if isTouching then
                self.state = 'reveal'
            end
        end
    }
end