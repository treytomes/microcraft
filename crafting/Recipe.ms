Recipe = new ListItem

// @param {Item} resultTemplate
// @returns {Recipe}
Recipe.init = function(resultTemplate)
    // @type {Item[]}
    self.costs = []
    self.canCraft = false
    self.resultTemplate = resultTemplate
    return self
end function

// @param {Resource} resource
// @param {int} count
// @returns {Recipe}
Recipe.addCost = function(resource, count)
    self.costs.push (new ResourceItem).init(resource, count)
    return self
end function

// @param {Player} player
Recipe.checkCanCraft = function(player)
    for i in range(0, self.costs.len - 1)
        item = self.costs[i]
        if item isa ResourceItem then
            ri = item;
            if not player.inventory.hasResources(ri.resource, ri.count) then
                self.canCraft = false
                return
            end if
        end if
    end for
    self.canCraft = true
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
Recipe.renderInventory = function(screen, x, y)
    screen.render(x, y, self.resultTemplate.getSprite(), self.resultTemplate.getColor(), 0)
    if canCraft then
        textColor = Color.get(-1, 555, 555, 555)
    else
        textColor = Color.get(-1, 222, 222, 222)
    end if
    Font.draw(resultTemplate.getName(), screen, x + 8, y, textColor)
end function

// @param {Player} player
Recipe.craft = function(player)
end function

// @param {Player} player
Recipe.deductCost = function(player)
    for i in range(0, self.costs.len - 1)
        item = self.costs[i]
        if item isa ResourceItem then
            ri = item;
            player.inventory.removeResource(ri.resource, ri.count)
        end if
    end for
end function

return Recipe
