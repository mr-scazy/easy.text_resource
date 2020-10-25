-- Module: text_resource

local M = {}
local current_language_block = {}
local default_language_block = {}
local data = {}

-- You can override this members in your script
M.filename_pattern = "/assets/text/%s.json"
M.default_language = "en"
M.current_language = ""
M.languages = {	M.default_language }

function M.init()
	if M.current_language == "" or M.current_language == nil then
		M.current_language = sys.get_sys_info().language
	end
	for i, language in ipairs(M.languages) do
		local filename = string.format(M.filename_pattern, language)
		local file, error = sys.load_resource(filename)
		if file then
			data[language] = json.decode(file)
		else
			print(error)
		end
	end
	default_language_block = data[M.default_language]
	current_language_block = data[M.current_language]
	if current_language_block == nil then
		current_language_block = default_language_block
	end
end

function M.get(key)
	local value = current_language_block[key]
	if value == nil then
		value = default_language_block[key]
	end
	if value == nil then
		value = key
	end
	return value
end

function M.change_current_language(language)
	local language_block = data[language]
	if language_block == nil then
		print(string.format("Language block for '%s' language not exist.", language))		
	else
		M.current_language = language
		current_language_block = language_block
	end
end

return M