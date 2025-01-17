local save = ya.sync(function(st, counts)
	st.counts = counts
	ya.render()
end)

local function setup(st, opts)
	st.counts = {}

	Linemode:children_add(function(self)
		if self._file.cha.is_dir and next(st.counts) then
			local count = st.counts[tostring(self._file.url)]
			return " " .. tostring(count)
		else
			return ""
		end
	end, opts.order or 4000)
end

local function fetch(self, args)
	local counts = {}

	for _, file in ipairs(args.files) do
    		if file.cha.is_dir then counts[tostring(file.url)] = file:count() end
	end

	save(counts)

	return 3
end

return { setup = setup, fetch = fetch }
