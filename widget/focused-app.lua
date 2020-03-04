local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local gears = require('gears')
local beautifu = require('beautiful')

local function list_update(w, buttons, label, data, objects)
  -- update the widgets, creating them if needed
  w:reset()
  for i, o in ipairs(objects) do
    local cache = data[o]
    local cb, tb, cbm, bgb, tbm, l
    if cache then
      tb = cache.tb
      bgb = cache.bgb
      tbm = cache.tbm
    else
      ib = wibox.widget.imagebox()
      tb = wibox.widget.textbox()
      bgb = wibox.container.background()
      tbm = wibox.container.margin(tb, dpi(4), dpi(8))
      l = wibox.layout.flex.horizontal()

      -- All of this is added in a fixed widget
      l:fill_space(true)
      l:add(tbm)

      -- And all of this gets a background
      bgb:set_widget(l)


      data[o] = {
        tb = tb,
        bgb = bgb,
        tbm = tbm,
      }
    end

    local text, bg, bg_image, icon, args = label(o, tb)
    args = args or {}

    -- The text might be invalid, so use pcall.
    if text == nil or text == '' then
      tbm:set_margins(0)
    else
      -- truncate when title is too long
      if not tb:set_markup_silently(text) then
        tb:set_markup('<i>&lt;Invalid text&gt;</i>')
      end
    end
    if type(bg_image) == 'function' then
      -- TODO: Why does this pass nil as an argument?
      bg_image = bg_image(tb, o, nil, objects, i)
    end

    bgb.shape = args.shape
    bgb.shape_border_width = args.shape_border_width
    bgb.shape_border_color = args.shape_border_color

    w:add(bgb)
  end
end
local tasklist_buttons =
  --awful.button(
  wibox.widget(
    {},
    1,
    function(c)
      return
    end
  )

local FocusedApp = function(s)
  return awful.widget.tasklist(
    s,
    awful.widget.tasklist.filter.focused,
    tasklist_buttons,
    {},
    list_update,
    wibox.layout.flex.horizontal()
  )
end

return FocusedApp
