-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- config.color_scheme = 'Builtin Solarized Light'
config.color_scheme = 'Builtin Solarized Dark'
-- config.font_dirs = {'/Users/spi/Library/Fonts/'}
-- config.font = wezterm.font 'Fira Code'

-- and finally, return the configuration to wezterm
return config
