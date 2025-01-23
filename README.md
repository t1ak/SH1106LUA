# SH1106LUA
simple driver for OLED SH1106 written in LUA

# ESP32 Lua/NodeMCU framebuffer + module for SH1106 OLEDs

This repository contains a Lua module (`SH1106.lua`), framebuffer
(`framebuffer.lua`) and fonts (`pixeloperator.lua`, `terminus16.lua`)
for using **SH1106**-based OLEDs with ESP32/NodeMCU firmware.

## Dependencies

SH1106.lua and framebuffer.lua have been tested with 
Lua 5.1.4 on ESP-IDF v3.3-beta1 integer build
They require the following modules.

* bit
* i2c

## Usage

Copy **framebuffer.lua**, **SH1106.lua** and (depending on your font choice)
**pixeloperator.lua** or **terminus16.lua** to your NodeMCU board and set them
up as follows.

test.lua

i2c.setup(0, sda_pin, scl_pin, i2c.SLOW)

sh1106 = require("SH1106")

fn = require("pixeloperator") -- or "terminus16"

fb = require("framebuffer")

collectgarbage()


sh1106.init(128, 64) -- assuming that a 128x64 OLED is connected

sh1106.contrast(255) -- maximum contrast

fb.init(132, 64) -- initialize framebuffer for 128x64 pixels

fb.print(fn, "Hello from NodeMCU!")

sh1106.show(fb.buf)

:-)

based on the code provided by derf

https://github.com/derf/esp8266-nodemcu-ssd1306/tree/main

tech info for SH1106:

https://www.crystalfontz.com/controllers/datasheet-viewer.php?id=468

