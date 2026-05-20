local function setup()
	local tty = io.open("/dev/tty", "w")
	if tty then
		local prefix = "\x1b]7;file://" .. ya.host_name()
		ps.sub("cd", function()
			tty:write(prefix .. cx.active.current.cwd .. "\a")
			tty:flush()
		end)
	end
end

return {
	setup = setup
}
