local save = ya.sync(function(st, output)
	st.output = output
	ya.render()
end)

local function setup(st, opts)
	opts = opts or {}
	Header:children_add(function()
		return ui.Line { st.output or "" }
	end, opts.order or 900, opts.align or Header.RIGHT)

	local refresh = function()
		ya.manager_emit("plugin", { st._id })
	end

	ps.sub("cd", refresh)
	ps.sub("tab", refresh)
end

local function entry(_, job)
	local output = Command("fsfree"):output()
	save(output.stdout)
end

return {
	setup = setup,
	entry = entry,
}
