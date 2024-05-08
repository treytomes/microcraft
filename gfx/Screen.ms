Screen = {}

Screen.BIT_MIRROR_X = 1
Screen.BIT_MIRROR_Y = 2

Screen.dither = [ 0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5 ]

// @param {int} w
// @param {int} h
// @param {SpriteSheet} sheet
Screen.make = function(w, h, sheet)
    self.xOffset = 0
    self.yOffset = 0
    self.sheet = sheet
    self.w = w
    self.h = h

    self.displayIndex = null

    self.display = new PixelDisplay
    self.display.scale = Game.SCALE

    self.backBuffer = new PixelDisplay
    self.backBuffer.scale = Game.SCALE

    return self
end function

Screen.install = function(index=null)
    if index != null then self.displayIndex = index
    self.display.install self.displayIndex
    display(self.displayIndex).mode = self.display.mode
    display(self.displayIndex).scale = Game.SCALE
end function

Screen.flip = function
    tmp = self.backBuffer
    self.backBuffer = self.display
    self.display = tmp
    self.install
end function

// @param {int} color
Screen.clear = function(c)
    if c < 0 then
        self.backBuffer.clear color.clear
    else
        self.backBuffer.clear Game.COLORS[c]
    end if

    // self.pixels = [color] * self.w * self.h

    // for i in range(self.pixels.len - 1)
    //     self.pixels[i] = color
    // end for
end function

// @param {int} xp
// @param {int} yp
// @param {int} tile
// @param {int[]} colors
// @param {int} bits
Screen.render = function(xp, yp, tile, colors, bits)
    xp -= self.xOffset
    yp -= self.yOffset

    mirrorX = bitAnd(bits, Screen.BIT_MIRROR_X) > 0
    mirrorY = bitAnd(bits, Screen.BIT_MIRROR_Y) > 0

    xTile = tile % 32
    yTile = floor(tile / 32)
    toffs = xTile * 8 + yTile * 8 * self.sheet.width

    for y in range(0, 7)
        ys = y
        if mirrorY then ys = 7 - y
        if y + yp < 0 or y + yp >= self.h then continue
        for x in range(0, 7)
            if x + xp < 0 or x + xp >= self.w then continue

            xs = x
            if mirrorX then xs = 7 - x
            col = colors[self.sheet.pixels[xs + ys * self.sheet.width + toffs]]
            // col = bitAnd(floor(colors / (2 ^ (self.sheet.pixels[xs + ys * self.sheet.width + toffs] * 8))), 255)
            // col = (colors >> (sheet.pixels[xs + ys * sheet.width + toffs] * 8)) & 255;

            if col < 255 then
                // self.pixels[(x + xp) + (y + yp) * self.w] = col
                self.backBuffer.setPixel(x + xp, self.h - (y + yp) - 1, Game.COLORS[col])
            end if
        end for
    end for
end function

// @param {int} xOffset
// @param {int} yOffset
Screen.setOffset = function(xOffset, yOffset)
    self.xOffset = xOffset
    self.yOffset = yOffset

    // self.display.scrollX = self.xOffset
    // self.display.scrollY = self.yOffset

    // self.backBuffer.scrollX = self.xOffset
    // self.backBuffer.scrollY = self.yOffset
end function

// @param {Screen} screen2
// @param {int} xa
// @param {int} ya
Screen.overlay = function(screen2, xa, ya)
    // oPixels = screen2.pixels
    i = 0
    for y in range(0, self.h - 1)
        for x in range(0, self.w - 1)
            // if floor(oPixels[i] / 10) <= self.dither[bitAnd((x + xa), 3) + bitAnd((y + ya), 3) * 4] then
            //     self.pixels[i] = 0
            // end if

            clr = color.toList(screen2.display.pixel(x, screen2.h - y - 1))
            clr = (clr[0] + clr[1] + clr[2]) / 3
            if floor(clr / 10) <= self.dither[bitAnd((x + xa), 3) + bitAnd((y + ya), 3) * 4] then
                self.backBuffer.setPixel(x, self.h - y - 1, Game.COLORS[0])
            end if

            i += 1
        end for
    end for
end function

// @param {int} x
// @param {int} y
// @param {int} r
Screen.renderLight = function(x, y, r)
    x -= self.xOffset
    y -= self.yOffset

    x0 = x - r
    x1 = x + r
    y0 = y - r
    y1 = y + r

    if x0 < 0 then x0 = 0
    if y0 < 0 then y0 = 0
    if x1 > w then x1 = self.w
    if y1 > h then y1 = self.h

    for yy in range(y0, y1 - 1) // The range feels off...?
        yd = yy - y
        yd = yd * yd
        for xx in range(x0, x1 - 1) // The range feels off...?
            xd = xx - x
            dist = xd * xd + yd
            if dist <= r * r then
                br = 255 - dist * 255 / (r * r)

                // if self.pixels[xx + yy * w] < br then
                //     self.pixels[xx + yy * w] = br
                // end if

                clr = color.toList(self.backBuffer.pixel(xx, self.h - yy - 1))
                clr = floor((clr[0] + clr[1] + clr[2]) / 3)
                if clr < br then
                    self.backBuffer.setPixel(xx, self.h - yy - 1, Game.COLORS[br])
                end if
            end if
        end for
    end for
end function

return Screen
