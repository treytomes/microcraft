CloudTile = new Tile

// @param {int} id
// @returns {CloudTile}
CloudTile.make = function(id)
    super.make(id)
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
CloudTile.render = function(screen, level, x, y)
    col = Color.get(444, 444, 555, 555)
    transitionColor = Color.get(333, 444, 555, -1)

    u = level.getTile(x, y - 1) == Tile.infiniteFall
    d = level.getTile(x, y + 1) == Tile.infiniteFall
    l = level.getTile(x - 1, y) == Tile.infiniteFall
    r = level.getTile(x + 1, y) == Tile.infiniteFall

    ul = level.getTile(x - 1, y - 1) == Tile.infiniteFall
    dl = level.getTile(x - 1, y + 1) == Tile.infiniteFall
    ur = level.getTile(x + 1, y - 1) == Tile.infiniteFall
    dr = level.getTile(x + 1, y + 1) == Tile.infiniteFall

    if not u and not l then
        if not ul then
            screen.render(x * 16 + 0, y * 16 + 0, 17, col, 0)
        else
            screen.render(x * 16 + 0, y * 16 + 0, 7 + 0 * 32, transitionColor, 3)
        end if
    else
        if l then
            lOffset = 6
        else
            lOffset = 5
        end if
        if u then
            uOffset = 2
        else
            uOffset = 1
        end if
        screen.render(x * 16 + 0, y * 16 + 0, lOffset + uOffset * 32, transitionColor, 3)
    end if

    if not u and not r then
        if not ur then
            screen.render(x * 16 + 8, y * 16 + 0, 18, col, 0)
        else
            screen.render(x * 16 + 8, y * 16 + 0, 8 + 0 * 32, transitionColor, 3)
        end if
    else
        if r then
            rOffset = 4
        else
            rOffset = 5
        end if
        if u then
            uOffset = 2
        else
            uOffset = 1
        end if
        screen.render(x * 16 + 8, y * 16 + 0, rOffset + uOffset * 32, transitionColor, 3)
    end if

    if not d and not l then
        if not dl then
            screen.render(x * 16 + 0, y * 16 + 8, 20, col, 0)
        else
            screen.render(x * 16 + 0, y * 16 + 8, 7 + 1 * 32, transitionColor, 3)
        end if
    else
        if l then
            lOffset = 6
        else
            lOffset = 5
        end if
        if d then
            dOffset = 0
        else
            dOffset = 1
        end if
        screen.render(x * 16 + 0, y * 16 + 8, lOffset + dOffset * 32, transitionColor, 3)
    end if
    if not d and not r then
        if not dr then
            screen.render(x * 16 + 8, y * 16 + 8, 19, col, 0)
        else
            screen.render(x * 16 + 8, y * 16 + 8, 8 + 1 * 32, transitionColor, 3)
        end if
    else
        if r then
            rOffset = r
        else
            rOffset = 5
        end if
        if d then
            dOffset = 0
        else
            dOffset = 1
        end if
        screen.render(x * 16 + 8, y * 16 + 8, rOffset + dOffset * 32, transitionColor, 3)
    end if
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
CloudTile.mayPass = function(level, x, y, e)
    return true
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
CloudTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.shovel then
            if player.payStamina(5) then
                count = Random.nextInt(2) + 1
                for i in range(0, count - 1)
                    level.add((new ItemEntity).make((new ResourceItem).make(Resource.cloud), xt * 16 + Random.nextInt(10) + 3, yt * 16 + Random.nextInt(10) + 3))
                end for
                return true
            end if
        end if
    end if
    return false
end function

return CloudTile
