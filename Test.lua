-- 102 oled sh1106 driver --date= 2025-01-23 16:40:40
-- dla integer firmware
-- https://github.com/derf/esp8266-nodemcu-ssd1306/tree/main
sda_pin=21 --ESP32 mini D1
scl_pin=22
i2c.setup(0, sda_pin, scl_pin, i2c.SLOW)
sh1106 = require("SH1106")
fn = require("pixeloperator") --terminus16")
if fn.height==8 then fb = require("framebuffer8")
      else fb = require("framebuffer16") end;
collectgarbage()

sh1106.init(132, 64) -- assuming that ( 2-129 ) x 64 pixels OLED is connected
sh1106.contrast(128) -- contrast 0 - 255
fb.init(132, 64) -- initialize framebuffer for ( 2-129 ) x 64 pixels
sh1106.ClearScreen(0)
fb.println(fn, "Witaj!")
fb.print(fn, " - - - ") fb.println(fn, "SH1106 - - -")
fb.print(fn, "___(c)Tad1ak 2025___",6)

