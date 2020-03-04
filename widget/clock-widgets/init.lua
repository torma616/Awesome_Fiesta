local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')

local dpi = require('beautiful').xresources.apply_dpi


local datetime_widget = wibox.widget {
  {
    format = '%a %b %d, %Y    %H:%M:',
    font = 'SF Display Bold 10',
    refresh = 1,
    widget = wibox.widget.textclock
  },
  widget = wibox.container.margin
}  

local seconds_widget = wibox.widget {
  {
    format = '%S',
    font = 'SF Mono Bold 10',
    refresh = 1,
    widget = wibox.widget.textclock
  },
  widget = wibox.container.margin
}

local clock_widget = wibox.widget {
  {
	  layout = wibox.layout.fixed.horizontal,
	  datetime_widget,
	  seconds_widget
  },
  left = 7,
  right = 7,
  widget = wibox.container.margin
}

local clock_button = clickable_container(clock_widget)
clock_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        _G.screen.primary.right_panel:toggle()
	_G.screen.primary.right_panel:switch_mode('widgets_mode')
      end
    )
  )
)

return clock_button
