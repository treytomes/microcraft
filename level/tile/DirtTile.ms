DirtTile = new Tile

// @param {int} id
// @returns {Tile}
DirtTile.make = function(id)
    super.make(id)
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
DirtTile.render = function(screen, level, x, y)
    col = Color.get(level.dirtColor, level.dirtColor, level.dirtColor - 111, level.dirtColor - 111)
    screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0)
    screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0)
    screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0)
    screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
DirtTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.shovel then
            if player.payStamina(4 - tool.level) then
                level.setTile(xt, yt, Tile.hole, 0)
                level.add((new ItemEntity).make((new ResourceItem).make(Resource.dirt), xt * 16 + Random.nextInt(10) + 3, yt * 16 + Random.nextInt(10) + 3))
                Sounds.monsterHurt.play
                return true
            end if
        end if
        if tool.type == ToolType.hoe then
            if player.payStamina(4 - tool.level) then
                level.setTile(xt, yt, Tile.farmland, 0)
                Sounds.monsterHurt.play
                return true
            end if
        end if
    end if
    return false
end function

return DirtTile
