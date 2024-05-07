SandTile = new Tile

// @param {int} id
// @returns {Tile}
SandTile.make = function(id)
    super.make(id)
    self.connectsToSand = true
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
SandTile.render = function(screen, level, x, y)
    col = Color.get(level.sandColor + 2, level.sandColor, level.sandColor - 110, level.sandColor - 110)
    transitionColor = Color.get(level.sandColor - 110, level.sandColor, level.sandColor - 110, level.dirtColor)

    u = not level.getTile(x, y - 1).connectsToSand
    d = not level.getTile(x, y + 1).connectsToSand
    l = not level.getTile(x - 1, y).connectsToSand
    r = not level.getTile(x + 1, y).connectsToSand

    steppedOn = level.getData(x, y) > 0

    if not u and not l then
        if not steppedOn then
            screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0)
        else
            screen.render(x * 16 + 0, y * 16 + 0, 3 + 1 * 32, col, 0)
        end if
    else
        screen.render(x * 16 + 0, y * 16 + 0, iif(l, 11, 12) + iif(u, 0, 1) * 32, transitionColor, 0)
    end if

    if not u and not r then
        screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0)
    else
        screen.render(x * 16 + 8, y * 16 + 0, iif(r, 13, 12) + iif(u, 0, 1) * 32, transitionColor, 0)
    end if

    if not d and not l then
        screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0)
    else
        screen.render(x * 16 + 0, y * 16 + 8, iif(l, 11, 12) + iif(d, 2, 1) * 32, transitionColor, 0)
    end if
    if not d and not r then
        if not steppedOn then
            screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0)
        else
            screen.render(x * 16 + 8, y * 16 + 8, 3 + 1 * 32, col, 0)
        end if
    else
        screen.render(x * 16 + 8, y * 16 + 8, iif(r, 13, 12) + iif(d, 2, 1) * 32, transitionColor, 0)
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
SandTile.tick = function(level, xt, yt)
    d = level.getData(xt, yt)
    if d > 0 then level.setData(xt, yt, d - 1)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Entity} entity
SandTile.steppedOn = function(level, xt, yt, entity)
    if entity isa Mob then
        level.setData(xt, yt, 10)
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
SandTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.shovel then
            if player.payStamina(4 - tool.level) then
                level.setTile(xt, yt, Tile.dirt, 0)
                level.add((new ItemEntity).make((new ResourceItem).make(Resource.sand), xt * 16 + Random.nextInt(10) + 3, yt * 16 + Random.nextInt(10) + 3))
                return true
            end if
        end if
    end if
    return false
end function

return SandTile
