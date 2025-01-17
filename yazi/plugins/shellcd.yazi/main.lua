return { entry = function(_, job)
	local arguments = table.concat(job.args, " ")
	local output = Command("sh")
		:arg("-c"):arg(arguments)
		:stdout(Command.PIPED):stderr(Command.PIPED)
		:output()

	if output.status.success then
		local path = tostring(output.stdout)
		if string.sub(path, -1) == "\n" then
			path = string.sub(path, 0, string.len(path) - 1)
		end
		ya.manager_emit("cd", { path })
	else
		ya.err(tostring(output.stderr))
	end
end }
