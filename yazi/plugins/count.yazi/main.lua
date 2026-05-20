local save = ya.sync(function(st, counts)
	for key, value in pairs(counts) do
		st.counts[key] = value
	end
	ui.render()
end)

local function setup(st, opts)
	st.counts = {}

	Linemode:children_add(function(self)
		if self._file.in_current and self._file.cha.is_dir and next(st.counts) then
			local count = st.counts[tostring(self._file.url)]
			if count == nil then return "" end
			return " " .. count
		else
			return ""
		end
	end, opts.order or 4000)
end

local function fetch(_, job)
	local counts = {}

	for _, file in ipairs(job.files) do
		local files, _ = fs.read_dir(file.url, {})
		counts[tostring(file.url)] = #files
	end

	save(counts)

	return 3
end

return { setup = setup, fetch = fetch }
