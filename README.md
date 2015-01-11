Pipman Propeller watch
======================

The Pipman is a GPS average intelligence (not dumb, but not quit smart like pebble) watch that runs on the propeller platform.  It boasts:

* 1 Gb internal memory (for saving calendar info and saving GPS coordinates)
* GPS (with time syncing abilities, can get local time anywhere in the world)
* Tilt Compensated Compass
* Temperature reader
* Color Screen
* Calendar
* USB support


Note: The current code is beta ( I'm not going to pretend all of it is clean. Some parts are rubbish.  You know it, I know it, lets move on) and hardware specific. It can be easily tweaked to suit your needs, but if you want to create the watch exactly as is the parts are as follows:

* A 4d systems oled-128-G1 (http://old.4dsystems.com.au/prod.php?id=78)  (the G2 should work too)
* Any NEMA Gps (though for the PCB designs I used this one: http://www.mouser.com/ProductDetail/4D-Systems/GPS-PA6B/?qs=0tg2fxsCAusQqyNQtvdH%252bA%3D%3D)
* The Honeywell hmc6343 (http://www.digikey.com/product-detail/en/HMC6343/342-1056-ND/1692480.  If you know how to tweak I2C code it wouldn't be hard to get any compass moduel to work)
* 5 way switch for navigation (http://www.adafruit.com/products/504)

