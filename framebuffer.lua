-- 100 oled print --date= 2025-01-23 11:29:00
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
end

function fb.scroll(fonHe)
	for x = 0, fb.w-1 do
	  local h32=fb.h/32
	  for y = 1, h32 do                                           --8 16
			fb.buf[x*h32+ y-1 + 1] = bit.rshift(fb.buf[x*h32 + y] or 0, fonHe) or nil
			if y ~= h32 then                                                                                    --24 16
				fb.buf[x*h32 + y-1 + 1] = bit.bor(fb.buf[x*h32 + y] or 0, bit.lshift(fb.buf[x*h32 + y + 1] or 0, (32-fonHe))) or nil
			end
		end
	end
	fb.y = fb.y - fonHe
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

function fb.putX(font, c)
	if c == 10 then
		fb.x = 0
		fb.y = fb.y + font.height
		--if fb.y>=64 then fb.y=48 end
		return
	end
	
	if (fb.y) >= fb.h then
	  print("scrol",fb.y)
		fb.scroll(font.height) 
		fb.y=fb.h-font.height
	end
	
	if c < 32 or c > 126 then
		c = 0x3f
	end
	
	local glyph = font.glyphs[c - 31]
	local fh = font.height/8
	for i = 1, string.len(glyph) do
		local x1 = (i-1) / fh
		local y8 = (i-1) % fh
		local fb8_o = fb.y/8+y8 + (fb.x+x1) * (fb.h/8)
		local fb32_o = fb8_o / 4 + 1
		local fb32_s = (fb8_o % 4) * 8
		fb.buf[fb32_o] = bit.bor(fb.buf[fb32_o] or 0, bit.lshift(string.byte(glyph, i), fb32_s))
		print(fb32_o,fb.buf[fb32_o])
	end
	
	fb.x = fb.x + string.len(glyph) / fh + 2
	if fb.x > fb.w then
		fb.put(font, 10)
	end
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
	sh1106.showT(fb.buf)
end

function fb.println(font, str,row)
  if row then rowGlb=row end
  fb.buf={}
	for i = 1, string.len(str) do
		fb.put(font, string.byte(str, i))
	end
	sh1106.showT(fb.buf)
	rowGlb=(rowGlb+2)
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
