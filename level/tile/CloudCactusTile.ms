CloudCactusTile = new Tile

// @param {int} id
// @returns {Tile}
CloudCactusTile.make = function(id)
    super.make(id)
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
CloudCactusTile.render = function(screen, level, x, y)
    color = Color.get(444, 111, 333, 555)
    screen.render(x * 16 + 0, y * 16 + 0, 17 + 1 * 32, color, 0)
    screen.render(x * 16 + 8, y * 16 + 0, 18 + 1 * 32, color, 0)
    screen.render(x * 16 + 0, y * 16 + 8, 17 + 2 * 32, color, 0)
    screen.render(x * 16 + 8, y * 16 + 8, 18 + 2 * 32, color, 0)
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
CloudCactusTile.mayPass = function(level, x, y, e)
    if e isa AirWizard then return true
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob | int} source
// @param {int | null} dmg
// @param {int | null} attackDir
CloudCactusTile.hurt = function(level, x, y, source, dmg = null, attackDir = null)
    if source isa Mob then
        self.hurt(level, x, y, 0)
    else
        dmg = source

        damage = level.getData(x, y) + 1
        level.add((new SmashParticle).make(x * 16 + 8, y * 16 + 8))
        level.add((new TextParticle).make("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)))
        if dmg > 0 then
            if damage >= 10 then
                level.setTile(x, y, Tile.cloud, 0)
            else
                level.setData(x, y, damage)
            end if
        end if
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
CloudCactusTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.pickaxe then
            if player.payStamina(6 - tool.level) then
                self.hurt(level, xt, yt, 1)
                return true
            end if
        end if
    end if
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Entity} entity
CloudCactusTile.bumpedInto = function(level, xt, yt, entity)
    if entity isa AirWizard then return
    entity.hurt(self, x, y, 3)
end function

return CloudCactusTile
