Menu = {}

Menu.make = function
    return self
end function

// @param {Game} game
// @param {InputHandler} input
Menu.init = function(game, input)
    self.input = input
    self.game = game
end function

Menu.tick = function
end function

// @param {Screen} screen
Menu.render = function(screen)
end function

// @param {Screen} screen
// @param {int} xo
// @param {int} yo
// @param {int} x1
// @param {int} y1
// @param {ListItem[]} listItems
// @param {int} selected
Menu.renderItemList = function(screen, xo, yo, x1, y1, listItems, selected)
    renderCursor = true
    if selected < 0 then
        selected = -selected - 1
        renderCursor = false
    end if
    w = x1 - xo
    h = y1 - yo - 1
    i0 = 0
    i1 = listItems.len
    if i1 > h then i1 = h
    io = selected - h / 2;
    if io > listItems.len - h then io = listItems.len - h
    if io < 0 then io = 0

    if listItems.len > 0 then
        for i in range(i0, i1 - 1)
            listOffset = i + io
            if listOffset >= 0 and listOffset < listItems.len then
                listItems[listOffset].renderInventory(screen, (1 + xo) * 8, (i + 1 + yo) * 8)
            end if
        end for
    end if

    if renderCursor then
        yy = selected + 1 - io + yo
        Font.draw(">", screen, (xo + 0) * 8, yy * 8, Color.get(5, 555, 555, 555))
        Font.draw("<", screen, (xo + w) * 8, yy * 8, Color.get(5, 555, 555, 555))
    end if
end function

return Menu
