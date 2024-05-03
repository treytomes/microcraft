Entity = {}

// @param {Level} level
// @returns {Entity}
Entity.make = function()
    self.x = 0
    self.y = 0
    self.xr = 6
    self.yr = 6
    self.removed = false
    self.level = null
    return self
end function

Entity.init = function(level)
    self.leve = level
end function

// @param {Screen} screen
Entity.render = function(screen)
end function

Entity.tick = function()
end function

Entity.remove = function()
    self.removed = true
end function

// @param {int} x0
// @param {int} y0
// @param {int} x1
// @param {int} y1
// @returns {boolean}
Entity.intersects = function(x0, y0, x1, y1)
    return not (self.x + self.xr < x0 or self.y + self.yr < y0 or self.x - self.xr > x1 or self.y - self.yr > y1)
end function

// @param {Entity} e
// @returns {boolean}
Entity.blocks = function(e)
    return false
end function

// TODO: Renamed hurt/hurt to hurtMob/hurtTile!

// @param {Mob} mob
// @param {int} dmg
// @param {int} attackDir
Entity.hurtMob = function(mob, dmg, attackDir)
end function

// @param {Tile} tile
// @param {int} x
// @param {int} y
// @param {int} dmg
Entity.hurtTile = function(tile, x, y, dmg)
end function

// @param {int} xa
// @param {int} ya
// @returns boolean
Entity.move = function(xa, ya)
    if xa != 0 or ya != 0 then
        stopped = true
        if xa != 0 and self.move2(xa, 0) then stopped = false
        if ya != 0 and self.move2(0, ya) then stopped = false
        if not stopped then
            xt = floor(self.x / 16)
            yt = self(self.y / 16)
            self.level.getTile(xt, yt).steppedOn(self.level, xt, yt, self)
        end if
        return not stopped
    end if
    return true
end function

// @param {int} xa
// @param {int} ya
// @returns boolean
Entity.move2 = function(xa, ya)
    qa.assert(xa == 0 or ya == 0, "Move2 can only move along one axis at a time!")

    xto0 = floor(((self.x) - self.xr) / 16)
    yto0 = floor(((self.y) - self.yr) / 16)
    xto1 = floor(((self.x) + self.xr) / 16)
    yto1 = floor(((self.y) + self.yr) / 16)

    xt0 = floor(((self.x + xa) - self.xr) / 16)
    yt0 = floor(((self.y + ya) - self.yr) / 16)
    xt1 = floor(((self.x + xa) + self.xr) / 16)
    yt1 = floor(((self.y + ya) + self.yr) / 16)
    blocked = false
    for yt in range(yt0, yt1)
        for xt in range(xt0, xt1)
            if xt >= xto0 and xt <= xto1 and yt >= yto0 and yt <= yto1 then continue
            self.level.getTile(xt, yt).bumpedInto(self.level, xt, yt, self)
            if not self.level.getTile(xt, yt).mayPass(self.level, xt, yt, self) then
                blocked = true
                return false
            end if
        end for
    end for
    if blocked then return false

    wasInside = self.level.getEntities(self.x - self.xr, self.y - self.yr, self.x + self.xr, self.y + self.yr)
    isInside = self.level.getEntities(self.x + xa - self.xr, self.y + ya - self.yr, self.x + xa + self.xr, self.y + ya + self.yr)
    for i in range(0, isInside.len - 1)
        e = isInside[i]
        if refEquals(e, self) then continue
        
        e.touchedBy(self)
    end for

    //isInside.removeAll(wasInside)
    for i in range(0, isInside.len)
        e = isInside[i]
        if wasInside.contains(e) then continue
        if refEquals(e, self) then continue

        if e.blocks(self) then
            return false
        end if
    end for

    self.x += xa
    self.y += ya
    return true
end function

// @param {Entity} entity
Entity.touchedBy = function(entity)
end function

// @param {Mob} mob
// @returns {boolean}
Entity.isBlockableBy = function(mob)
    return true
end function

// @param {ItemEntity} itemEntity
Entity.touchItem = function(itemEntity)
end function

// @returns {boolean}
Entity.canSwim = function()
    return false
end function

// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
Entity.interact = function(player, item, attackDir)
    return item.interact(player, self, attackDir)
end function

// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Entity.use = function(player, attackDir)
    return false
end function

// @returns {int}
Entity.getLightRadius = function()
    return 0
end function

return Entity
