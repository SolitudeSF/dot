local get_selected_dirs = ya.sync(function(_)
	local selected = {}
	for _, file in ipairs(cx.active.current.files) do
		if file.cha.is_dir and file:is_selected() then
			selected[#selected + 1] = file.url
		end
	end
	return selected
end)

local get_hovered_dir = ya.sync(function(_)
	local h = cx.active.current.hovered
	if h.cha.is_dir then
    		return h.url
	end
end)

local function update_size(url)
	local size = 0

	local it = fs.calc_size(url)
	while true do
		local next = it:recv()
		if next then
			size = size + next
		else
			break
		end
	end

	local op = fs.op("size", { url = url.parent, sizes = { [url.urn] = size } })
	ya.emit("update_files", { op = op })
	ui.render()
end

local function entry()
	local selected = get_selected_dirs()
	if #selected > 0 then
		for _, url in ipairs(selected) do
			update_size(url)
		end
	else
		local hovered = get_hovered_dir()
		if hovered then
			update_size(hovered)
		end
	end
end

return {
	entry = entry
}
