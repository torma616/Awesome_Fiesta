local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')

local dpi = require('beautiful').xresources.apply_dpi


local app_title = wibox.widget {
  {
    layout = wibox.layout.flex.horizontal,
    widget = awful.titlebar.widget.titlewidget(c)
  },
  left = 7,
  right = 7,
  widget = wibox.container.margin
}

return app_title
