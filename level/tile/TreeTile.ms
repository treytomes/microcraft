TreeTile = new Tile

// @param {int} id
// @returns {Tile}
TreeTile.make = function(id)
    super.make(id)
    self.connectsToGrass = true
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
TreeTile.render = function(screen, level, x, y)
    col = Color.get(10, 30, 151, level.grassColor)
    barkCol1 = Color.get(10, 30, 430, level.grassColor)
    barkCol2 = Color.get(10, 30, 320, level.grassColor)

    u = level.getTile(x, y - 1) == self
    l = level.getTile(x - 1, y) == self
    r = level.getTile(x + 1, y) == self
    d = level.getTile(x, y + 1) == self
    ul = level.getTile(x - 1, y - 1) == self
    ur = level.getTile(x + 1, y - 1) == self
    dl = level.getTile(x - 1, y + 1) == self
    dr = level.getTile(x + 1, y + 1) == self

    if u and ul and l then
        screen.render(x * 16 + 0, y * 16 + 0, 10 + 1 * 32, col, 0)
    else
        screen.render(x * 16 + 0, y * 16 + 0, 9 + 0 * 32, col, 0)
    end if
    if u and ur and r then
        screen.render(x * 16 + 8, y * 16 + 0, 10 + 2 * 32, barkCol2, 0)
    else
        screen.render(x * 16 + 8, y * 16 + 0, 10 + 0 * 32, col, 0)
    end if
    if d and dl and l then
        screen.render(x * 16 + 0, y * 16 + 8, 10 + 2 * 32, barkCol2, 0)
    else
        screen.render(x * 16 + 0, y * 16 + 8, 9 + 1 * 32, barkCol1, 0)
    end if
    if d and dr and r then
        screen.render(x * 16 + 8, y * 16 + 8, 10 + 1 * 32, col, 0)
    else
        screen.render(x * 16 + 8, y * 16 + 8, 10 + 3 * 32, barkCol2, 0)
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
TreeTile.tick = function(level, xt, yt)
    damage = level.getData(xt, yt)
    if damage > 0 then level.setData(xt, yt, damage - 1)
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
TreeTile.mayPass = function(level, x, y, e)
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob | int} source
// @param {int | null} dmg
// @param {int | null} attackDir
TreeTile.hurt = function(level, x, y, source, dmg = null, attackDir = null)
    if source isa Mob then
        self.hurt(level, x, y, dmg)
        return
    end if
    dmg = source

    count = iif(Random.nextInt(10) == 0, 1, 0)
    for i in range(0, count - 1)
        level.add((new ItemEntity).make((new ResourceItem).make(Resource.apple), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
    end for

    damage = level.getData(x, y) + dmg
    level.add((new SmashParticle).make(x * 16 + 8, y * 16 + 8))
    level.add((new TextParticle).make("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)))
    if damage >= 20 then
        count = Random.nextInt(2) + 1
        for i in range(0, count - 1)
            level.add((new ItemEntity).make((new ResourceItem).make(Resource.wood), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
        end for
        count = Random.nextInt(Random.nextInt(4) + 1)
        for i in range(0, count - 1)
            level.add((new ItemEntity).make((new ResourceItem).make(Resource.acorn), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
        end for
        level.setTile(x, y, Tile.grass, 0)
    else
        level.setData(x, y, damage)
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
TreeTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.axe then
            if player.payStamina(4 - tool.level) then
                self.hurt(level, xt, yt, Random.nextInt(10) + (tool.level) * 5 + 10)
                return true
            end if
        end if
    end if
    return false
end function

return TreeTile
