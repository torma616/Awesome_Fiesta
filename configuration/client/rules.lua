local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  -- Add `skip_decoration = true` to other rule_any to exclude that
  {
    rule = {},
    except_any = {
      instance = {
        'nm-connection-editor',
        'file_progress'
      }
    },
    properties = {
      round_corners = true,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen,
      floating = false,
      maximized = false,
      above = false,
      below = false,
      ontop = false,
      sticky = false,
      maximized_horizontal = false,
      maximized_vertical = false  
    }
  },


    -- Dialogs and modals
  {
    rule_any = {
      type = { 'dialog', 'modal' },
      class = {
        'Wicd-client.py',
        'calendar.google.com'
      }
    },
    properties = {
      ontop = true,
      floating = true,
      drawBackdrop = true,
      skip_decoration = true,
      shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius) end,
      placement = awful.placement.centered
    }
  },


  -- Terminals
  {
    rule_any = {
      class = {
        "mate-terminal",
	"URxvt",
        "XTerm",
        "UXTerm",
        "K3rmit"
       },
    },
    except_any = {
      instance = {
        -- Dont't switch to tag `1` when opening QuakeTerminal
        'QuakeTerminal',
      }
    },
    properties = {
      size_hints_honor = false,
      screen = 1, 
    }
  },

  -- Browsers
  {
    rule_any = {
      class = {
        "chromium",
      },
    },
    properties = { screen = 1 }
  },


  -- Editors
  {
    rule_any = {
      class = {
        "Geany",
        "Atom",
        "Subl3",
        "code-oss"
      },
    },
    properties = { screen = 1 }
  },

  -- File Managers
  {
    rule_any = {
       class = {
         "Nemo",
         "File-roller"
       },
    },
  },

    -- Multimedia
  {
    rule_any = {
      class = {
        "vlc"
       },
    },
  },

  -- Games
  {
  rule_any = {
    class = {
      "Wine",
      "dolphin-emu",
      "Steam",
      "Citra"
    },
  },
    properties = {
      screen = 1,
      floating = true,
      hide_titlebars = true
    }
  },

  -- Graphics Editing
  {
  rule_any = {
    class = {
      "Gimp-2.10",
      "Inkscape",
      "Flowblade"
    },
  },
    properties = { screen = 1 }
  },

  -- Virtualbox
  {
  rule_any = {
    class = {
      "VirtualBox Manage",
      "VirtualBox Machine"
    },
  },
    properties = { screen = 1 }
  },


  -- Workspace Editing and IDEs
  {
  rule_any = {
    class = {
      "Oomox",
      "Unity",
      "UnityHub",
      "jetbrains-studio"
    },
  },
    properties = { 
      screen = 1,
      skip_decoration = true,
      round_corners = true,
    }
  },

  -- Some floating apps
  {
  rule_any = {
    class = {
      "feh",
      "Mugshot",
      "Pulseeffects"
    },
  },
    properties = {
    skip_decoration = true,
    hide_titlebars = true,
    floating = true,
    ontop = true,
    placement = awful.placement.centered
    }
  },


  -- Instances
  -- Network Manager Editor
  {
    rule = {
      instance = 'nm-connection-editor'
    },
    properties = {
      skip_decoration = true,
      round_corners = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons
    }
  },
  
  -- For nemo progress bar when copying or moving
  {
    rule = {
      instance = 'file_progress'
    },
    properties = {
      skip_decoration = true,
      round_corners = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      placement = awful.placement.centered
    }
  },

  {
    -- For Firefox Popup when you open incognito mode
    rule = {
      instance = 'Popup'
    },
    properties = {
      skip_decoration = true,
      round_corners = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons
    }
  }
}


-- Normally we'd do this with a rule but Spotify and SuperTuxKart doesnt set
-- its class or name until is starts up, so we need to catch that signal
client.connect_signal("property::class",function(c)

  if c.class == 'Spotify' or c.class == 'SuperTuxKart' then
    -- Check if already opened
    local app = function(c)
      if c.class == 'SuperTuxKart' then
        return awful.rules.match(c, { class = 'SuperTuxKart' } )
      elseif c.class == 'Spotify' then
        return awful.rules.match(c, { class = 'Spotify' } )
      end
    end

    -- Move it to the desired tag in THIS SCREEN
    local tagName = ''
    t:view_only()

    if c.class == 'SuperTuxKart' then
      c.fullscreen = not c.fullscreen
      c:raise()
    end
  end
end)
