local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')

local tags = {
  {
    icon = icons.terminal,
    screen = 1
  },
  {
    icon = icons.chrome,
    screen = 1
  },
  {
    icon = icons.code,
    screen = 1
  },
  {
    icon = icons.folder,
    screen = 1
  },
  {
    icon = icons.music,
    screen = 1
  },
  {
    icon = icons.game,
    screen = 1
  },
  {
    icon = icons.art,
    screen = 1
  },
  {
    icon = icons.vbox,
    screen = 1
  },
  {
    icon = icons.lab,
    screen = 1
  }
}

awful.layout.layouts = {
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.tile,
  awful.layout.suit.max
}


screen.connect_signal("request::desktop_decoration", function(s)
  for i, tag in pairs(tags) do
    awful.tag.add(
      i,
      {
	icon = tag.icon,
        --icon_only = true,
        layout = awful.layout.suit.spiral.dwindle,
        gap_single_client = true,
        gap = 4,
        screen = s,
	index = i,
	selected = i == 1
      }
    )
  end
end)


_G.tag.connect_signal(
  'property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.max) then
      t.gap = 0
    else
      t.gap = 4
    end
  end
)
