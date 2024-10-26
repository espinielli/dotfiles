-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
--config.color_scheme = 'AdventureTime'
config.color_scheme = 'Solarized Light (Gogh)'

config.font = wezterm.font('Monaspace Argon')
config.font_size = 12.0
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
--config.font =
--  wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })

-- and finally, return the configuration to wezterm
return config
