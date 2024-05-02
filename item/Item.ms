Item = new ListItem
Item._class = "Item"

// @returns {int}
Item.getColor = function()
    return 0
end function

// @returns {int}
Item.getSprite = function()
    return 0
end function

// @param {ItemEntity} itemEntity
Item.onTake = function(itemEntity)
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
Item.renderInventory = function(screen, x, y)
end function

// @param {Player} player
// @param {Entity} entity
// @param {int} attackDir
// @returns {boolean}
Item.interact = function(player, entity, attackDir)
    return false
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
Item.renderIcon = function(screen, x, y)
end function

// @param {Tile} tile
// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Item.interactOn = function(tile, level, xt, yt, player, attackDir)
    return false
end function

// @returns {boolean}
Item.isDepleted = function()
    return false
end function

// @returns {boolean}
Item.canAttack = function()
    return false
end function

// @param {Entity} e
// @returns {int}
Item.getAttackDamageBonus = function(e)
    return 0
end function

// @returns {string}
Item.getName = function()
    return ""
end function

// @param {Item} item
// @returns {boolean}
Item.matches = function(item)
    return item._class == self._class
end function

return Item
