-- 102 drv SH1106 --date= 2025-01-23 10:39:50
local sh1106 = {} --date= 2025-01-21 22:17:42

local s_CONTRAST = 0x81
local s_ENTIRE_ON = 0xa4
local s_NORM_INV = 0xa6 --7
local s_DISP = 0xae -- ON/OFF  AF / AE
local s_MEM_ADDR = 0x20
local s_COL_ADDR = 0x21
local s_PAGE_ADDR = 0x22
local s_DISP_START_LINE = 0x40
local s_SEG_REMAP = 0xa1 -- A0 od prawej
local s_MUX_RATIO = 0xa8
local s_COM_OUT_DIR = 0xc0
local s_DISP_OFFSET = 0xd3
local s_COM_PIN_CFG = 0xda
local s_DISP_CLK_DIV = 0xd5
local s_PRECHARGE = 0xd9
local s_VCOM_DESEL = 0xdb
local s_CHARGE_PUMP = 0x8d

function sh1106.wc(byte)
	return sh1106.wd({0x80, byte})
end

function sh1106.wd(data)
	i2c.start(0)
	if not i2c.address(0, 0x3c, i2c.TRANSMITTER) then
		return false
	end
	i2c.write(0, data)
	i2c.stop(0)
	return true
end

function sh1106.init(width, height)
	sh1106.w = width
	sh1106.h = height
	local tab = {s_DISP, s_MEM_ADDR, 0x01, s_DISP_START_LINE, s_SEG_REMAP,
		s_MUX_RATIO, height - 1, s_COM_OUT_DIR + 0x08, s_DISP_OFFSET, 0x00,
		s_COM_PIN_CFG, height == 32 and 0x02 or 0x12, s_DISP_CLK_DIV, 0x80,
		s_PRECHARGE, 0x88, s_VCOM_DESEL, 0x30, s_CONTRAST, 0x80, s_ENTIRE_ON,
		s_NORM_INV, s_CHARGE_PUMP, 0x14, s_DISP + 0x01, s_COL_ADDR, 0, width-1,
		s_PAGE_ADDR, 0, height/8-1}
	for i, v in ipairs(tab) do
		sh1106.wc(v)
	end
end

function sh1106.contrast(contrast)
	local tab = {s_CONTRAST, contrast}
	for i, v in ipairs(tab) do
		sh1106.wc(v)
	end
end

function sh1106.showT(fb)
	local txbuf = {0x40}
	local idx=2
	for i = 1, #fb, 2 do
	  txbuf[idx]=fb[i]
	  idx=idx+1
	end	  
	  sh1106.wc(0xb0+rowGlb) -- + row) -- set page address 0-7
    sh1106.wc(2)  -- set low col address
    sh1106.wc(16) -- + col) -- set high col address
		sh1106.wd(txbuf)
		
		txbuf = {0x40} 
		idx=2
	for i = 2, #fb, 2 do
	  txbuf[idx]=fb[i]
	  idx=idx+1
	end
	  sh1106.wc(0xb0+rowGlb+1) -- + row)   
    sh1106.wc(2)  -- set low col address
    sh1106.wc(16) -- + col) -- set high col address
		sh1106.wd(txbuf)
end

function sh1106.show(fb)
	local txbuf = {0x40}
	for i = 1, sh1106.w * sh1106.h / 32, 32 do
		for j = 0, 31 do
			local dw = fb[i+j] or 0
			for k = 2, 5 do
				txbuf[j*4+k] = bit.band(dw, 0xff)
				dw = bit.rshift(dw, 8)
			end
		end
		sh1106.wd(txbuf)
		print(i, txbuf[1], txbuf[2], txbuf[3], txbuf[4], #txbuf)
	end
end

function sh1106.FillScreen(col,row,ile,war)
  local txbuf = {0x40,129,129}
-- Set the cursor position in a 16 COL * 8 ROW map.
    sh1106.wc(0xb0 + row)      -- set page address
    sh1106.wc(2)  -- set low col address
    sh1106.wc(16+col) -- set high col address
    for i=2,ile do txbuf[i]=war end
    sh1106.wd(txbuf)
end

function sh1106.ClearScreen(war)
  local txbuf = {0x40}
  for i=2,131 do txbuf[i]=war end
  for row=0, 7 do
    sh1106.wc(0xb0 + row)      -- set page address
    sh1106.wc(0)  -- set low col address
    sh1106.wc(16) -- set high col address
    sh1106.wd(txbuf)
  end  
end
return sh1106
