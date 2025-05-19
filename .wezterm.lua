local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux


-- 基本設定
config.automatically_reload_config = true 
config.window_close_confirmation = "NeverPrompt"
config.default_cursor_style = "SteadyBar"

-- For example, changing the color scheme:
config.color_scheme = 'Afterglow'

-- colors
config.color_scheme = "nord"
config.window_background_opacity = 0.93
-- font
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 14.0


-- タブバー設定
config.tab_bar_at_bottom = true
config.tab_max_width = 5


-- イベントハンドラ
-- 起動時に画面を最大化
wezterm.on("gui-startup", function()
    local _, _, window = mux.spawn_window({})
    window:gui_window():maximize()
end)

-- タブタイトルのフォーマット
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"

	if tab.is_active then
	  background = "#9c7af2"
	  foreground = "#FFFFFF"
	end

	local edge_foreground = background
	local title = tab.active_pane.title

	-- タイトルが長い場合は省略
	local function get_last_n_chars(str, n)
        if #str <= n then
            return str
        else
            return "…" .. string.sub(str, -n + 1)
        end
    end

	-- プロセス名に基づいてタイトルを取得する関数(nodeとかmakeとか表示)
    local function get_process_name(pane)
        local process_name = pane.foreground_process_name

    	return process_name:match("([^/]+)$") or ""

    end

    -- カスタムタイトルを取得する関数
    local function get_custom_title(pane)
        local process_name = get_process_name(pane)

		if process_name ~= "zsh" then
			return process_name
        else
             return get_last_n_chars(title, 23)
         end

		return process_name
    end

    -- カスタムタイトルを取得
    local custom_title = get_custom_title(tab.active_pane)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
	  { Background = { Color = background } },
	  { Foreground = { Color = foreground } },
	  { Text = " " .. (tab.tab_index + 1) .. ": " .. custom_title .. " " },
	  { Background = { Color = edge_background } },
	  { Foreground = { Color = edge_foreground } },
	  { Text = SOLID_RIGHT_ARROW },
	}
end)

-- and finally, return the configuration to wezterm
return config

