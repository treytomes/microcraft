HardRockTile = new Tile

// @param {int} id
// @returns {Tile}
HardRockTile.make = function(id)
    super.make(id)
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
HardRockTile.render = function(screen, level, x, y)
    col = Color.get(334, 334, 223, 223)
    transitionColor = Color.get(001, 334, 445, level.dirtColor)

    u = level.getTile(x, y - 1) != self
    d = level.getTile(x, y + 1) != self
    l = level.getTile(x - 1, y) != self
    r = level.getTile(x + 1, y) != self

    ul = level.getTile(x - 1, y - 1) != self
    dl = level.getTile(x - 1, y + 1) != self
    ur = level.getTile(x + 1, y - 1) != self
    dr = level.getTile(x + 1, y + 1) != self

    if not u and not l then
        if not ul then
            screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0)
        else
            screen.render(x * 16 + 0, y * 16 + 0, 7 + 0 * 32, transitionColor, 3)
        end if
    else
        screen.render(x * 16 + 0, y * 16 + 0, iif(l, 6, 5) + iif(u, 2, 1) * 32, transitionColor, 3)
    end if

    if not u and not r then
        if not ur then
            screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0)
        else
            screen.render(x * 16 + 8, y * 16 + 0, 8 + 0 * 32, transitionColor, 3)
        end if
    else
        screen.render(x * 16 + 8, y * 16 + 0, iif(r, 4, 5) + iif(u, 2, 1) * 32, transitionColor, 3)
    end if

    if not d and not l then
        if not dl then
            screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0)
        else
            screen.render(x * 16 + 0, y * 16 + 8, 7 + 1 * 32, transitionColor, 3)
        end if
    else
        screen.render(x * 16 + 0, y * 16 + 8, iif(l, 6, 5) + iif(d, 0, 1) * 32, transitionColor, 3)
    end if
    if not d and not r then
        if not dr then
            screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0)
        else
            screen.render(x * 16 + 8, y * 16 + 8, 8 + 1 * 32, transitionColor, 3)
        end if
    else
        screen.render(x * 16 + 8, y * 16 + 8, iif(r, 4, 5) + iif(d, 0, 1) * 32, transitionColor, 3)
    end if
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
HardRockTile.mayPass = function(level, x, y, e)
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob | int} source
// @param {int | null} dmg
// @param {int | null} attackDir
HardRockTile.hurt = function(level, x, y, source, dmg = null, attackDir = null)
    if source isa Mob then
        self.hurt(level, x, y, 0)
        return
    end if

    dmg = source
    damage = level.getData(x, y) + dmg
    level.add((new SmashParticle).make(x * 16 + 8, y * 16 + 8))
    level.add((new TextParticle).make("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)))
    if damage >= 200 then
        count = Random.nextInt(4) + 1
        for i in range(0, count - 1)
            level.add((new ItemEntity).make((new ResourceItem).make(Resource.stone), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
        end for
        count = Random.nextInt(2)
        for i in range(0, count - 1)
            level.add((new ItemEntity).make((new ResourceItem).make(Resource.coal), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
        end for
        level.setTile(x, y, Tile.dirt, 0)
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
HardRockTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.pickaxe and tool.level == 4 then
            if player.payStamina(4 - tool.level) then
                self.hurt(level, xt, yt, Random.nextInt(10) + (tool.level) * 5 + 10)
                return true
            end if
        end if
    end if
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
HardRockTile.tick = function(level, xt, yt)
    damage = level.getData(xt, yt)
    if damage > 0 then level.setData(xt, yt, damage - 1)
end function

return HardRockTile
