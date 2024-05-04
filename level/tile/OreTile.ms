OreTile = new Tile

// @param {int} id
// @param {Resource} toDrop
// @returns {OreTile}
OreTile.make = function(id, toDrop)
    super.make(id)
    self.toDrop = toDrop
    self.color = bitAnd(toDrop.color, 16776960) // 0xffff00
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
OreTile.render = function(screen, level, x, y)
    color = bitAnd(toDrop.color, 4294967040) + Color.get(level.dirtColor) // 0xffffff00
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
OreTile.mayPass = function(level, x, y, e)
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob | int} source
// @param {int | null} dmg
// @param {int | null} attackDir
OreTile.hurt = function(level, x, y, source, dmg = null, attackDir = null)
    if source isa Mob then
        self.hurt(level, x, y, 0)
        return
    end if

    dmg = source
    damage = level.getData(x, y) + 1
    level.add((new SmashParticle).make(x * 16 + 8, y * 16 + 8))
    level.add((new TextParticle).make("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)))
    if dmg > 0 then
        count = Random.nextInt(2)
        if damage >= Random.nextInt(10) + 3 then
            level.setTile(x, y, Tile.dirt, 0)
            count += 2
        else
            level.setData(x, y, damage)
        end if
        for i in range(0, count - 1)
            level.add((new ItemEntity).make((new ResourceItem).make(toDrop), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
        end for
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
OreTile.interact = function(level, xt, yt, player, item, attackDir)
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
OreTile.bumpedInto = function(level, xt, yt, entity)
    entity.hurt(self, x, y, 3)
end function

return OreTile
