PowerGloveItem = new Item
PowerGloveItem._class = "PowerGloveItem"

// @returns {PowerGloveItem}
PowerGloveItem.make = function
    return self
end function

// @returns {int}
PowerGloveItem.getColor = function()
    return Color.get(-1, 100, 320, 430)
end function

// @returns {int}
PowerGloveItem.getSprite = function()
    return 7 + 4 * 32
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
PowerGloveItem.renderIcon = function(screen, x, y)
    screen.render(x, y, self.getSprite(), self.getColor(), 0)
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
PowerGloveItem.renderInventory = function(screen, x, y)
    screen.render(x, y, self.getSprite(), self.getColor(), 0)
    Font.draw(self.getName(), screen, x + 8, y, Color.get(-1, 555, 555, 555))
end function

// @returns {string}
PowerGloveItem.getName = function()
    return "Pow glove"
end function

// @param {Player} player
// @param {Entity} entity
// @param {int} attackDir
// @returns {boolean}
PowerGloveItem.interact = function(player, entity, attackDir)
    if entity isa Furniture then
        f = entity
        f.take(player)
        return true
    end if
    return false
end function

return PowerGloveItem
