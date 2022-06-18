BLTLogs = blt_class(BLTModule)
BLTLogs.__type = "BLTLogs"

function BLTLogs:init()
	BLTLogs.super.init(self)

	self.logs_location = "mods/logs/"
	self.logs_lifetime = {
		[1] = {1, "blt_logs_one_day"},
		[2] = {3, "blt_logs_three_days"},
		[3] = {7, "blt_logs_one_week"},
		[4] = {14, "blt_logs_two_weeks"},
		[5] = {30, "blt_logs_thirty_days"}
	}
	self.day_length = 86400
end

function BLTLogs:LogNameToNumber(name)
	local year, month, day = name:match("^([0-9]+)_([0-9]+)_([0-9]+)_log.txt$")
	if not year or not month or not day then
		return -1
	end
	return Utils:TimestampToEpoch(year, month, day)
end

function BLTLogs:CleanLogs(lifetime)
	lifetime = lifetime or 1

	BLT:Log(LogLevel.INFO, string.format("[BLT] Cleaning logs folder, lifetime %i day(s)", lifetime))

	local current_time = os.time()
	local files = file.GetFiles(self.logs_location)
	if files then
		for i, file_name in pairs(files) do
			local file_date = self:LogNameToNumber(file_name)
			if file_date > 0 and file_date < current_time - (lifetime * self.day_length) then
				BLT:Log(LogLevel.INFO, string.format("[BLT] Removing log: %s", file_name))
				os.remove(string.format("%s%s", self.logs_location, file_name))
			end
		end
	end
end
