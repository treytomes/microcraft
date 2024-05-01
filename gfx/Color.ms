Color = {}

Color.get = function(a, b=null, c=null, d=null)
    if b == null and c == null and d == null then
        if a < 0 then return 255
		r = floor(a / 100) % 10
		g = floor(a / 10) % 10
		b = a % 10
		return r * 36 + g * 6 + b
    else
		return (self.get(d) * 2^24) + (self.get(c) * 2^16) + (self.get(b) * 2^8) + (self.get(a))
    end if
end function