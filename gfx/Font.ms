Font = {}

Font.chars = " " +
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ      " +
    "0123456789.,!?'""-+=/\\%()<>:;     " +
    " "

// @param {String} msg
// @param {Screen} screen
// @param {int} x
// @param {int} y
// @param {int} col
Font.draw = function(msg, screen, x, y, col)
    msg = msg.upper()
    for i in range(0, msg.len - 1)
        ix = self.chars[msg[i]]
        if ix >= 0 then
            screen.render(x + i * 8, y, ix + 30 * 32, col, 0)
        end if
    end for
end function

// @param {Screen} screen
// @param {String} title
// @param {int} x0
// @param {int} y0
// @param {int} x1
// @param {int} y1
Font.renderFrame = function(screen, title, x0, y0, x1, y1)
    for y in range(y0, y1)
        for x in range(x0, x1)
            if x == x0 and y == y0 then
                screen.render(x * 8, y * 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 0)
            else if x == x1 and y == y0 then
                screen.render(x * 8, y * 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 1)
            else if x == x0 and y == y1 then
                screen.render(x * 8, y * 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 2)
            else if x == x1 and y == y1 then
                screen.render(x * 8, y * 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 3)
            else if y == y0 then
                screen.render(x * 8, y * 8, 1 + 13 * 32, Color.get(-1, 1, 5, 445), 0)
            else if y == y1 then
                screen.render(x * 8, y * 8, 1 + 13 * 32, Color.get(-1, 1, 5, 445), 2)
            else if x == x0 then
                screen.render(x * 8, y * 8, 2 + 13 * 32, Color.get(-1, 1, 5, 445), 0)
            else if x == x1 then
                screen.render(x * 8, y * 8, 2 + 13 * 32, Color.get(-1, 1, 5, 445), 1)
            else
                screen.render(x * 8, y * 8, 2 + 13 * 32, Color.get(5, 5, 5, 5), 1)
            end if
        end for
    end for

    self.draw(title, screen, x0 * 8 + 8, y0 * 8, Color.get(5, 5, 5, 550))
end function

return Font
