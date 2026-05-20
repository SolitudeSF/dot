local label = nil

local function setup(st, opts)
	opts = opts or {}
	Header:children_add(function()
		return ui.Line { label or "" }
	end, opts.order or 900, opts.align or Header.RIGHT)

	local refresh = function()
		ya.async(function ()
			label = Command("fsfree"):output().stdout
			ui.render()
		end)
	end

	ps.sub("cd", refresh)
	ps.sub("tab", refresh)
end

return {
	setup = setup,
	entry = entry,
}
