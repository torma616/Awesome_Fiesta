local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TagList = require('widget.tag-list')
local TaskList = require('widget.task-list')
local FocusedApp = require('widget.focused-app')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')



-- Create to each screen
screen.connect_signal("request::desktop_decoration", function(s)
  s.systray = wibox.widget.systray()
  s.systray.visible = false
  s.systray:set_horizontal(true)
  s.systray:set_base_size(28)
  s.systray.opacity = 0.3
  beautiful.systray_icon_spacing = 16
end)


-- Execute only if system tray widget is not loaded
awesome.connect_signal("toggle_tray", function()
  if not require('widget.systemtray') then
    if awful.screen.focused().systray.visible ~= true then
      awful.screen.focused().systray.visible = true
    else
      awful.screen.focused().systray.visible = false
    end
  end
end)


local TopPanel = function(s, offset)
  local offsetx = 0
  if offset == true then
    offsetx = dpi(45)
  end
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      type = 'dock',
      height = dpi(26),
      width = s.geometry.width,
      x = s.geometry.x,
      y = s.geometry.y,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(26)
      }
    }
  )

  panel:struts(
    {
      top = dpi(26)
    }
  )

  
  local vSeparator = wibox.widget {
	orientation = 'vertical',
	forced_width = 5,
	opacity = 0,
	span_ratio = 0.5,
	widget = wibox.widget.separator
  }
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  local LayoutBox = function(s)
    local layoutBox = clickable_container(awful.widget.layoutbox(s))
    layoutBox:buttons(
      awful.util.table.join(
        awful.button(
          {},
          1,
          function()
            awful.layout.inc(1)
          end
        ),
        awful.button(
          {},
          3,
          function()
            awful.layout.inc(-1)
          end
        ),
        awful.button(
          {},
          4,
          function()
            awful.layout.inc(1)
          end
        ),
        awful.button(
          {},
          5,
          function()
            awful.layout.inc(-1)
          end
        )
      )
    )
    return layoutBox
  end

  panel:setup {
    expand = "none",
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      require('widget.mini-settings'),
      FocusedApp(s),
      --TagList(s)
    },
    {
      layout = wibox.layout.fixed.horizontal,
      TagList(s),
      vSeparator,
      TaskList(s)
   },
   {
      layout = wibox.layout.fixed.horizontal,
      s.systray,
      require('widget.systemtray'),
      require('widget.package-updater'),
      require('widget.bluetooth'),
      require('widget.wifi'),
      require('widget.battery'),
      require('widget.clock-widgets'),
      LayoutBox(s),
      require('widget.right-dashboard')
    }
  }

  return panel
end

return TopPanel
