ToolItem = new Item
ToolItem._class = "ToolItem"

// @type {int}
ToolItem.MAX_LEVEL = 5

// @type {string[]}
ToolItem.LEVEL_NAMES = [ "Wood", "Rock", "Iron", "Gold", "Gem" ]

// @type {int[]}
ToolItem.LEVEL_COLORS = [
    Color.get(-1, 100, 321, 431),
    Color.get(-1, 100, 321, 111),
    Color.get(-1, 100, 321, 555),
    Color.get(-1, 100, 321, 550),
    Color.get(-1, 100, 321, 055),
]

// @param {ToolType} type
// @param {int} level
// @returns {ToolItem}
ToolItem.make = function(type, level)
    self.type = type
    self.level = level
    return self
end function

// @returns {int}
ToolItem.getColor = function()
    return ToolItem.LEVEL_COLORS[self.level]
end function

// @returns {int}
ToolItem.getSprite = function()
    return self.type.sprite + 5 * 32
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
ToolItem.renderIcon = function(screen, x, y)
    screen.render(x, y, self.getSprite(), self.getColor(), 0)
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
ToolItem.renderInventory = function(screen, x, y)
    screen.render(x, y, self.getSprite(), self.getColor(), 0)
    Font.draw(self.getName(), screen, x + 8, y, Color.get(-1, 555, 555, 555))
end function

// @returns {string}
ToolItem.getName = function()
    return ToolItem.LEVEL_NAMES[level] + " " + self.type.name
end function

// @param {ItemEntity} itemEntity
ToolItem.onTake = function(itemEntity)
end function

// @returns {boolean}
ToolItem.canAttack = function()
    return true
end function

// @param {Entity} e
// @returns {int}
ToolItem.getAttackDamageBonus = function(e)
    if self.type == ToolType.axe then
        return (self.level + 1) * 2 + floor(Random.nextFloat * 4)
    end if
    if self.type == ToolType.sword then 
        return (self.level + 1) * 3 + floor(Random.nextFloat * (2 + self.level * self.level * 2));
    end if
    return 1
end function

// @param {Item} item
// @returns {boolean}
ToolType.matches = function(item)
    if item isa ToolItem then
        other = item
        if other.type != self.type then return false
        if other.level != self.level then return false
        return true
    end if
    return false
end function

return ToolItem
