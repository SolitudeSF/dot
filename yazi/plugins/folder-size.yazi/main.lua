local get_selected_dirs = ya.sync(function(st)
	local selected = {}
	for i, file in ipairs(cx.active.current.files) do
		if file.cha.is_dir and file:is_selected() then
			selected[#selected + 1] = tostring(file.url)
		end
	end
	return selected
end)

local get_hovered = ya.sync(function(st)
	local h = cx.active.current.hovered
	if h.cha.is_dir then
    		return tostring(h.url)
	end
end)

local save_size = ya.sync(function(st, path, size)
	st.sizes[path] = size
	ya.render()
end)

local function setup(st, opts)
	st.sizes = {}
	opts.order = opts.order or 1200

	Linemode:children_add(function(self)
    		if self._file.cha.is_dir and next(st.sizes) then
        		local size = st.sizes[tostring(self._file.url)]
        		if size then
            			return " " .. size
        		else
            			return ""
        		end
    		end
	end, opts.order)
end

local function get_size(path)
	local output = Command("du")
		:arg("-sh"):arg(path)
		:stdout(Command.PIPED):stderr(Command.PIPED)
		:output()

	if output.status.success then
		return string.sub(output.stdout, 1, string.find(output.stdout, "\t") - 1)
	end
end

local function entry()
	local selected = get_selected_dirs()
	if #selected > 0 then
    		for _, path in ipairs(selected) do
        		local size = get_size(path)
        		if size then
            			save_size(path, size)
        		end
		end
	else
		local hovered = get_hovered()
		if hovered then
    			local size = get_size(hovered)
    			if size then
    				save_size(hovered, size)
			end
		end
	end
end

return {
	setup = setup,
	entry = entry,
}
