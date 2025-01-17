require("session"):setup {
	sync_yanked = true,
}

require("count"):setup {
	order = 900
}

require("git"):setup {
	order = 800
}

require("folder-size"):setup {
	order = 850
}

require("free-space"):setup {}

function Linemode:size()
	local size = self._file:size()
	if size then
		return ui.Line(ya.readable_size(size))
	else
    		return ui.Line {}
	end
end

function Status:owner()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line {}
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	}
end

function Status:modified()
	local time = cx.active.current.hovered and cx.active.current.hovered.cha.mtime
	return ui.Span(time and os.date(" %y-%m-%d %H:%M ", time // 1) or " "):fg("blue")
end

Status:children_remove(5, Status.RIGHT) -- remove percentage
Status:children_add("owner", 900, Status.RIGHT)
Status:children_add("modified", 1500, Status.RIGHT)

function Header:tabs()
	local tabs = #cx.tabs
	if tabs == 1 then
		return ui.Line {}
	end

	local spans = {}
	for i = 1, tabs do
		local text = i
		if THEME.manager.tab_width > 2 then
			text = ya.truncate(text .. " " .. cx.tabs[i]:name(), { max = THEME.manager.tab_width })
		end
		if i == cx.tabs.idx then
			spans[#spans + 1] = ui.Span(" " .. text .. " "):style(THEME.manager.tab_active)
		else
			spans[#spans + 1] = ui.Span(" " .. text .. ":" .. cx.tabs[i].current.cwd:name() .. " "):style(THEME.manager.tab_inactive)
		end
	end
	return ui.Line(spans)
end
