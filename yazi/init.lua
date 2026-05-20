require("session"):setup { sync_yanked = true }
require("count"):setup { order = 1100 }
require("git"):setup { order = 800 }
require("zoxide"):setup { update_db = true }
require("free-space"):setup {}
require("report-cwd"):setup {}

function Linemode:size()
	local size = self._file:size()
	if size then
		return ui.Line(ya.readable_size(size))
	else
    		return ui.Line {}
	end
end

function Preview:click(event, up)
	if up or event.is_middle then
		return
	end

	local y = event.y - self._area.y + 1
	local window = self._folder and self._folder.window or {}
	if window[y] then
		Entity:new(window[y]):click(event, up)
	elseif not up then
		if event.is_left then
			ya.emit("enter", {})
		elseif event.is_right then
			ya.emit("plugin", { "toggle-pane", "max-preview" })
		end
	end
end

function Status:owner()
	local h = cx.active.current.hovered
	if h == nil then
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
