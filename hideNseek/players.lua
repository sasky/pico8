hidingPlaces = {
    {x = 0, y= 0 ,toX = 0, toY = 0},
    {x = 0, y= 0 ,toX = 0, toY = 0},
    {x = 0, y= 0 ,toX = 0, toY = 0},

}
function init_player(name, px, py, w, h, x, y, state, hidingPlaces, s)
    s = s or 1
    -- if state is hide
    if state == 'title' then
    elseif state == 'hide' then
    elseif state == 'play' then
        ---- then assign x,y to starting coords
    end

    return {
        -- constants
        name = name,
        -- pixel map
        px = px,
        py = py,
        w = w,
        h = h,
        -- state
        state = state,
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
        update = function(self)
            self.vx = 0
            self.vy = 0
            local oldx = self.x
            local oldy = self.y
            -- printh("player update: " .. self.state, 'debug.log', false)

            -- bounds
            -- check if
            -- movement
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
            elseif self.state == "reveal" then
                -- todo, step though the reveal animation
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
            if not self:canMove(oldx, oldy) then
                self.x = oldx
                self.y = oldy
            end
        end,
        draw = function(self)
            sspr(self.pxf, self.py, self.w, self.h, self.x, self.y, self.w, self.h, self.vx < 0)
            if (self.state == "title_selected") rect(self.x - 2, self.y - 2, self.x + self.w + 2, self.y + self.h + 2, 3)
            -- local hitbox = self:getHitBox()
            -- rect(hitbox.x0, hitbox.y0, hitbox.x1, hitbox.y1, 6)
        end,
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
        end,
        found = function(self, x, y)
            -- todo
            -- has this hiden player been found
        end,
        start = function(self, state)
            if state == 'play' then
                self.x = 18
                self.y = 20
            elseif state == 'hide' then
                ---- then assign the player to a random
                ----  hiding place (from provided hiding places)
                self.x = 120
                self.y = 120
            end
            self.state = state
        end,
        -- active player private functions
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
                --todo, col detection based off flags
                -- the tiles you can walk on are marked with the 0 flag
                local b = self:getHitBox()
                local tl =  fget(mget(b.x0 / 8, b.y0 / 8), 1)
                local tr =  fget(mget(b.x1 / 8, b.y0 / 8), 1)
                local bl =  fget(mget(b.x0 / 8, b.y1 / 8), 1)
                local br =  fget(mget(b.x1 / 8, b.y1 / 8), 1)
                -- if self.state == 'play' then
                --     printh("top left x: " .. b.x0, 'debug.log', false)
                --     printh("top left y: " .. b.y0, 'debug.log', false)
                --     printh("top left map: " .. mget(b.x0 / 8, b.y0 / 8), 'debug.log', false)
                --     printh("top left: " .. tostr(tl), 'debug.log', false)
                --     printh("top right: " .. tostr(tr), 'debug.log', false)
                --     printh("bottom left: " .. tostr(tl), 'debug.log', false)
                --     printh("bottom right: " .. tostr(tl), 'debug.log', false)
                -- end

                return tl and tr and bl and br
            end
            return true
        end,
        -- active player public functions
    }
end