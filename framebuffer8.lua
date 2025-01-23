-- 100 oled print --date= 2025-01-23 16:10:28
local fb = {}

fb.w = 0
fb.h = 0
fb.x = 0
fb.y = 0
fb.buf = nil

function fb.init(w, h)
	fb.w = w
	fb.h = h
	fb.x = 0
	fb.y = 0
	fb.buf = {}
	rowGlb = 0
	xGlb=0
end

function HxGlb()
  return bit.arshift(xGlb,4)
end
function LxGlb()
  return bit.band(xGlb,15)
end

 function fb.put(font, c)
 
  if c == 10 then 
    rowGlb=rowGlb+font.height/8
    if rowGlb>7 then rowGlb=0 end
		return
	end
	
	local glyph = font.glyphs[c - 31]
	local idx=#fb.buf
	 for i = 1, string.len(glyph) do
		fb.buf[idx+i] = string.byte(glyph, i)
   end
   idx=#fb.buf fb.buf[idx+1] = 0 fb.buf[idx+2] = 0
 end

function fb.printT(font, c1, c2)
  fb.buf={}
	for i = c1, c2 do
		fb.put(font, i)
	end
end

function fb.print(font, str,row)
  if row then rowGlb=row end
  fb.buf={}
	for i = 1, string.len(str) do
		fb.put(font, string.byte(str, i))
	end
	sh1106.show8(fb.buf)
end

function fb.println(font, str,row)
  if row then rowGlb=row end
  fb.buf={}
	for i = 1, string.len(str) do
		fb.put(font, string.byte(str, i))
	end
	sh1106.show8(fb.buf)
	rowGlb=rowGlb+2
	xGlb=0
end

function fb.draw_battery_8(x, y, p)
	fb.buf[y/32 + x*fb.h/32 + 1] = 0xff
	for i = 1, 10 do
		if p*2 >= i*15 then
			fb.buf[y/32 + (x+i)*fb.h/32 + 1] = 0xff
		else
			fb.buf[y/32 + (x+i)*fb.h/32 + 1] = 0x81
		end
	end
	if p*2 >= 11*15 then
		fb.buf[y/32 + (x+11)*fb.h/32 + 1] = 0xff
	else
		fb.buf[y/32 + (x+11)*fb.h/32 + 1] = 0xe7
	end
	if p*2 >= 12*15 then
		fb.buf[y/32 + (x+12)*fb.h/32 + 1] = 0x3c
	else
		fb.buf[y/32 + (x+12)*fb.h/32 + 1] = 0x24
	end
	fb.buf[y/32 + (x+13)*fb.h/32 + 1] = 0x3c
end

return fb
