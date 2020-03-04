local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local HOME = os.getenv('HOME')

local dpi = require('beautiful').xresources.apply_dpi

panel_visible = false

local right_panel = function(screen)
  local panel_width = dpi(350)
  local panel = wibox {
    ontop = true,
    screen = screen,
    type = 'dock',
    width = panel_width,
    height = screen.geometry.height,
    x = screen.geometry.width - panel_width,
    bg = beautiful.background.hue_800,
    fg = beautiful.fg_normal,
  }

  panel.opened = false

  local backdrop = wibox
  {
    ontop = true,
    screen = screen,
    bg = '#00000000',
    type = 'utility',
    x = screen.geometry.x,
    y = screen.geometry.y,
    width = screen.geometry.width,
    height = screen.geometry.height
  }

  panel:struts(
  {
    right = 0
  }
  )

openPanel = function()
  panel_visible = true
  backdrop.visible = true
  panel.visible = true
  panel:emit_signal('opened')
end

closePanel = function()
panel_visible = false
panel.visible = false
backdrop.visible = false
-- Change to notif mode on close
_G.switch_mode('notif_mode')
panel:emit_signal('closed')
end

-- Hide this panel when app dashboard is called.
function panel:HideDashboard()
  closePanel()
end

function panel:toggle()
  self.opened = not self.opened
  if self.opened then
    openPanel()
  else
    closePanel()
  end
end


function panel:switch_mode(mode)
  if mode == 'notif_mode' then
    -- Update Content
    panel:get_children_by_id('notif_id')[1].visible = true
    panel:get_children_by_id('widgets_id')[1].visible = false
  elseif mode == 'widgets_mode' then
    -- Update Content
    panel:get_children_by_id('notif_id')[1].visible = false
    panel:get_children_by_id('widgets_id')[1].visible = true
  end
end

backdrop:buttons(
  awful.util.table.join(
    awful.button(
      {},
      1,
      function()
        panel:toggle()
      end
    )
  )
)


-- Calendar theme
local styles = {}
local function rounded_shape(size, partial)
  if partial then
    return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height,
      false, true, false, true, 5)
    end
  else
    return function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, size)
    end
  end
end
styles.month   = { 
  padding = 5,
  bg_color = '#00000000',
}
styles.normal  = {
  fg_color = '#f2f2f2',
  bg_color = '#00000000'
}
styles.focus   = {
  fg_color = '#f2f2f2',
  bg_color = '#007af7',
  markup   = function(t) return '<b>' .. t .. '</b>' end
}
styles.header  = {
  fg_color = '#f2f2f2',
  bg_color = '#00000000',
  markup   = function(t) return '<b>' .. t .. '</b>' end
}
styles.weekday = { 
  fg_color = '#ffffff',
  bg_color = '#00000000',
  markup   = function(t) return '<b>' .. t .. '</b>' end
}
local function decorate_cell(widget, flag, date)
  if flag=='monthheader' and not styles.monthheader then
    flag = 'header'
  end
  local props = styles[flag] or {}
  if props.markup and widget.get_text and widget.set_markup then
    widget:set_markup(props.markup(widget:get_text()))
  end
  -- Change bg color for weekends
  local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
  local weekday = tonumber(os.date('%w', os.time(d)))
  local default_bg = (weekday==0 or weekday==6) and '#232323' or '#383838'
  local ret = wibox.widget {
    {
      widget,
      margins = (props.padding or 2) + (props.border_width or 0),
      widget  = wibox.container.margin
    },
    shape              = props.shape,
    shape_border_color = props.border_color or '#b9214f',
    shape_border_width = props.border_width or 0,
    fg                 = props.fg_color or '#999999',
    bg                 = props.bg_color or default_bg,
    widget             = wibox.container.background
  }
  return ret
end

-- Calendar Widget
local cal = wibox.widget {
  {
    date = os.date('*t'),
    font = 'SF Pro Display Regular 12',
    start_sunday = true,
    fn_embed = decorate_cell,
    spacing = dpi(10),
    long_weekdays = false,
    widget   = wibox.widget.calendar.month
  },
  margins = dpi(2),
  widget = wibox.container.margin
}

-- Time Summary
local week_day = wibox.widget {
  format = '%A',
  font = 'SF Pro Display Bold 14',
  refresh = 1,
  widget = wibox.widget.textclock

}
local date = wibox.widget {
  format = '%B %d, %Y',
  font = 'SF Pro Display Regular 12',
  refresh = 1,
  widget = wibox.widget.textclock
}
local separator = wibox.widget {
  orientation = 'horizontal',
  opacity = 0.0,
  forced_height = 15,
  widget = wibox.widget.separator,
}

local line_separator = wibox.widget {
  orientation = 'horizontal',
  forced_height = 15,
  span_ratio = 1.0,
  opacity = 0.90,
  color = beautiful.bg_modal,
  widget = wibox.widget.separator
}

panel:setup {
  expand = 'none',
  layout = wibox.layout.fixed.vertical,
  separator,
  {
    expand = 'none',
    layout = wibox.layout.align.horizontal,
    nil,
    require('widget.right-dashboard.subwidgets.panel-mode-switcher'),
    nil,
  },
  separator,
  line_separator,
  {
    layout = wibox.layout.stack,
    -- Notification Center
    {
      id = 'notif_id',
      visible = true,
      separator,
      {
        {
          layout = wibox.layout.fixed.vertical,
          require('widget.notif-center'),
        },
        left = dpi(15),
        right = dpi(15),
        widget = wibox.container.margin
      },
      layout = wibox.layout.fixed.vertical,
    },
    -- Widget Center
    {
      id = 'widgets_id',
      visible = false,
      layout = wibox.layout.fixed.vertical,
      separator,
      {
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(10),
          week_day,
          date,
          require('widget.user-profile'),
          --require('widget.email'),
          require('widget.weather'),
          cal
        },
        left = dpi(15),
        right = dpi(15),
        widget = wibox.container.margin
      },

    }

  }

}


return panel
end


return right_panel
