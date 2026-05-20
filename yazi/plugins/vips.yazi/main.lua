local M = {}

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err = self:preload(job)
	if not ok or err then
		return
	end

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))
	local _, err = ya.image_show(cache, job.area)
	ya.preview_widget(job, err)
end

function M:seek() end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then
		return true
	end

	local cache_str = tostring(cache)

	local cmd = Command("vipsthumbnail"):arg({
		tostring(job.file.url),
		"--vips-concurrency=1",
		"--size", string.format("%dx%d", rt.preview.max_width, rt.preview.max_height),
		"-o", cache_str .. ".jpg[Q=" .. tostring(rt.preview.image_quality) .. ",profile=none,strip=true]"
	})

	local status, err = cmd:status()

	if status then
    		os.rename(cache_str .. ".jpg", cache_str)
    		return status.success
	else
    		return true, Err("Failed to start ", err)
	end
end

function M:spot(job) require("file"):spot(job) end

return M
