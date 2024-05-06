CraftingMenu = new Menu

// @param {Recipe[]} recipes
// @param {Player} player
CraftingMenu.make = function(recipes, player)
    self.selected = 0

    self.recipes = recipes
    self.player = player

    for i in range(0, self.recipes.len - 1)
        self.recipes[i].checkCanCraft(player)
    end for

    self.recipes.sort "canCraft"
end function

CraftingMenu.tick = function
    if self.input.menu.clicked then self.game.setMenu(null)

    if self.input.up.clicked then self.selected -= 1
    if self.input.down.clicked then self.selected += 1

    len = self.recipes.len
    if len == 0 then self.selected = 0
    if self.selected < 0 then self.selected += len
    if self.selected >= len then self.selected -= len

    if self.input.attack.clicked and len > 0 then
        r = self.recipes[self.selected]
        r.checkCanCraft(player)
        if r.canCraft then
            r.deductCost(player)
            r.craft(player)
            Sound.craft.play
        end if
        for i in range(0, recipes.len - 1)
            self.recipes[i].checkCanCraft(player)
        end for
    end if
end function

// @param {Screen} screen
CraftingMenu.render = function(screen)
    Font.renderFrame(screen, "Have", 12, 1, 19, 3)
    Font.renderFrame(screen, "Cost", 12, 4, 19, 11)
    Font.renderFrame(screen, "Crafting", 0, 1, 11, 11)
    self.renderItemList(screen, 0, 1, 11, 11, self.recipes, self.selected)

    if self.recipes.len > 0 then
        recipe = self.recipes[self.selected]
        hasResultItems = self.player.inventory.count(recipe.resultTemplate)
        xo = 13 * 8
        screen.render(xo, 2 * 8, recipe.resultTemplate.getSprite, recipe.resultTemplate.getColor, 0)
        Font.draw("" + hasResultItems, screen, xo + 8, 2 * 8, Color.get(-1, 555, 555, 555))

        costs = recipe.costs
        for i in range(0, costs.len - 1)
            item = costs[i]
            yo = (5 + i) * 8
            screen.render(xo, yo, item.getSprite, item.getColor, 0)
            requiredAmt = 1;
            if item isa ResourceItem then
                requiredAmt = item.count
            end if
            has = player.inventory.count(item)
            color = Color.get(-1, 555, 555, 555)
            if has < requiredAmt then
                color = Color.get(-1, 222, 222, 222)
            end if
            if has > 99 then has = 99
            Font.draw("" + requiredAmt + "/" + has, screen, xo + 8, yo, color)
        end for
    end if
end function

return CraftingMenu
