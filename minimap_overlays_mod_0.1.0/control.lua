local flib_gui = require("__flib__.gui")
-- local flib_gui_skin = require("__flib__.gui-skin")
-- local flib_gui_style = require("__flib__.gui-style")
-- local flib_gui_checkbox = require("__flib__.gui-checkbox")

-- Verify if the overlays are enabled
local function overlays_enabled()
  return settings.startup["minimap_overlays_enabled"].value
end

-- Option that updates the GUI if overlays are enabled
local function update_overlay(player)
  if not overlays_enabled() then
    return
  end

  -- Delete the previous window if it already exists
  if player.gui.left.minimap_overlay then
    player.gui.left.minimap_overlay.destroy()
  end

  -- Get pollution and nearby enemies
  local pollution = game.surfaces[1].get_pollution(player.position)
  local enemies = game.surfaces[1].find_entities_filtered{
    type = "unit",
    force = "enemy",
    position = player.position,
    radius = 50 -- TODO: Make this configurable (default: 50)
  }

  -- Create the new GUI
  flib_gui.build(player.gui.left, {
    type = "frame",
    name = "minimap_overlay",
    direction = "vertical",
    {
      type = "label",
      caption = "Nearby enemies: " .. #enemies
    }
  })
end

-- Event that updates the overlays every 60 ticks (1 second)
script.on_event(defines.events.on_tick, function(event)
  if event.tick % 60 == 0 then
    for _, player in pairs(game.connected_players) do
      update_overlay(player)
      -- TODO: Update the overlays for every player
    end
  end
end)