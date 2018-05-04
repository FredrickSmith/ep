
-- JSON fixed for NULL & large numbers

local json = {}
do
	json.null = {}
	local function kind_of(obj)
		if type(obj) ~= 'table' then return type(obj) end
		if obj == json.null     then return 'null'    end
		local i = 1
		for _ in pairs(obj) do if obj[i] ~= nil then i = i + 1 else return 'table' end end
		if i == 1 then return 'table' else return 'array' end
	end
	local function escape_str(s)
		local out_char = {'\\', '"', '/',	'b',	'f',	'n',	'r',	't'}
		for i, c in ipairs({'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}) do s = s:gsub(c, '\\' .. out_char[i]) end
		return s
	end
	local function skip_delim(str, pos, delim, err_if_missing)
		pos = pos + #str:match('^%s*', pos)
		if str:sub(pos, pos) ~= delim then
			if err_if_missing then error('Expected ' .. delim .. ' near position ' .. pos) end
			return pos, false
		end
		return pos + 1, true
	end
	local function parse_str_val(str, pos, val)
		val = val or ''
		local early_end_error = 'End of input found while parsing string.'
		if pos > #str then error(early_end_error) end
		local c = str:sub(pos, pos)
		if c == '"'	then return val, pos + 1 end
		if c ~= '\\' then return parse_str_val(str, pos + 1, val .. c) end
		local esc_map = {b = '\b', f = '\f', n = '\n', r = '\r', t = '\t'}
		local nextc = str:sub(pos + 1, pos + 1)
		if not nextc then error(early_end_error) end
		return parse_str_val(str, pos + 2, val .. (esc_map[nextc] or nextc))
	end
	local function parse_num_val(str, pos)
		local num_str = str:match('^-?%d+%.?%d*[eE]?[+-]?%d*', pos)
		local val = tonumber(num_str)
		if not val then error('Error parsing number at position ' .. pos .. '.') end
		return val, pos + #num_str
	end

	function json.stringify(obj, as_key)
		local s = {}
		local kind = kind_of(obj)
		if kind == 'array' then
			if as_key then error('Can\'t encode array as key.') end
			s[#s + 1] = '['
			for i, val in ipairs(obj) do
				if i > 1 then s[#s + 1] = ', ' end
				s[#s + 1] = json.stringify(val)
			end
			s[#s + 1] = ']'
		elseif kind == 'table' then
			if as_key then error('Can\'t encode table as key.') end
			s[#s + 1] = '{'
			for k, v in pairs(obj) do
				if #s > 1 then s[#s + 1] = ', ' end
				s[#s + 1] = json.stringify(k, true)
				s[#s + 1] = ':'
				s[#s + 1] = json.stringify(v)
			end
			s[#s + 1] = '}'
		elseif kind == 'string' then return '"' .. escape_str(obj) .. '"'
		elseif kind == 'number' then
			if as_key then return '"' .. string.format ("%.0f", obj) .. '"' end
			return string.format ("%.0f", obj)
		elseif kind == 'boolean' then return tostring(obj)
		elseif kind == 'nil'     then return 'null'
		elseif kind == 'null'    then return 'null'
		else
			error('Unjsonifiable type: ' .. kind .. '.')
		end
		return table.concat(s)
	end
	function json.parse(str, pos, end_delim)
		pos = pos or 1
		if pos > #str then error('Reached unexpected end of input.') end
		local pos = pos + #str:match('^%s*', pos)
		local first = str:sub(pos, pos)
		if first == '{' then
			local obj, key, delim_found = {}, true, true
			pos = pos + 1
			while true do
				key, pos = json.parse(str, pos, '}')
				if key == nil then return obj, pos end
				if not delim_found then error('Comma missing between object items.') end
				pos = skip_delim(str, pos, ':', true)
				obj[key], pos = json.parse(str, pos)
				pos, delim_found = skip_delim(str, pos, ',')
			end
		elseif first == '[' then
			local arr, val, delim_found = {}, true, true
			pos = pos + 1
			while true do
				val, pos = json.parse(str, pos, ']')
				if val == nil then return arr, pos end
				if not delim_found then error('Comma missing between array items.') end
				arr[#arr + 1] = val
				pos, delim_found = skip_delim(str, pos, ',')
			end
		elseif first == '"'                      then return parse_str_val(str, pos + 1)
		elseif first == '-' or first:match('%d') then return parse_num_val(str, pos)
		elseif first == end_delim                then return nil, pos + 1
		else
			local literals = {['true'] = true, ['false'] = false, ['null'] = json.null}
			for lit_str, lit_val in pairs(literals) do
				local lit_end = pos + #lit_str - 1
				if str:sub(pos, lit_end) == lit_str then return lit_val, lit_end + 1 end
			end
			local pos_info_str = 'position ' .. pos .. ': ' .. str:sub(pos, pos + 10)
			error('Invalid json syntax starting at ' .. pos_info_str)
		end
	end
end

-- PrintTable

-- waste of time
function table.GetKeys(a)local b={}local c=1;for d,e in pairs(a)do b[c]=d;c=c+1 end;return b end;function PrintTable(f,g,h)h=h or{}g=g or 0;local b=table.GetKeys(f)table.sort(b,function(i,j)if isnumber(i)and isnumber(j)then return i<j end;return tostring(i)<tostring(j)end)for k=1,#b do local l=b[k]local m=f[l]print(string.rep("\t",g))if istable(m)and not h[m]then h[m]=true;print(tostring(l)..":".."\n")PrintTable(m,g+2,h)h[m]=nil else print(tostring(l).."\t=\t")print(tostring(m).."\n")end end end

-- remade
local PrintTable
PrintTable = function (a, t)
	t = t or 0
	for b, c in pairs (a) do
		print (t ~= 0 and ('	'):rep (t) or '', b, type (c) ~= 'table' and (type (c) == 'number' and string.format ("%.0f", c) or c) or '')
		if type (c) == 'table' then
			PrintTable (c, t + 1)
		end
	end
end

-- TimesRetry

local a = [[]]
local b = json.parse (a)

local t = function (a) return type (a) == 'table' end
for a = 1, #b.questionTimes do
	local b = b.questionTimes [a]
	print (a, b.QuestionID, b.Correct, b.Attempts)
end
	
local c = json.stringify (b)
print (c)

-- Clean nz.co.LanguagePerfect.Services.PortalsAsync.App.AppServicesPortal.GetAppDataForActivitySelection

local a = [[]]
print (a:match ('"Collections":({.+}),"Stats"'))

-- Scrape nz.co.LanguagePerfect.Services.PortalsAsync.App.AppServicesPortal.GetAppDataForActivitySelection

local a = [[]]
local b = json.parse (a)
local c = {}

for d = 1, #b.Generic do
	c [b.Generic [d].ID] = {}
	for e = 1, #b.Generic [d].Words do
		c [b.Generic [d].ID] [#c [b.Generic [d].ID] + 1] = b.Generic [d].Words [e]
	end
end

print (json.stringify (c))
c = json.parse (json.stringify (c))

-- Editing nz.co.LanguagePerfect.Services.PortalsAsync.App.AppServicesPortal.StoreActivityUsageData3
-- Single

local a = [[]]
      a = json.parse (a)
local b = ''
      b = json.parse (b)

local c, e, y, gg = a.params [2] [1].UserID, {}, 0, {}

for f = 1, #a.params [3] do
	e [#e + 1] = a.params [3] [f].ListID
	e [#e + 1] = a.params [3] [f].LearningContext
end

a.params [2] = {}
a.params [3] = {}

for f = 1, #e / 2 , 2 do
	local g = b [''..e [f]]
	local z = 0
	for h = 1, #g do
		local t, tt = math.random (6, 11), math.random (6, 11)
		z = z + t + tt
		a.params [2] [#a.params [2] + 1] = {
			UserID          = c,
			QuestionID      = g [h],
			Time            = t,
			TimeMS          = json.null,
			Correct         = true,
			Attempts        = 1,
			ListID          = e [f],
			LearningContext = e [f + 1]
		}
		a.params [2] [#a.params [2] + 1] = {
			UserID          = c,
			QuestionID      = g [h],
			Time            = tt,
			TimeMS          = json.null,
			Correct         = true,
			Attempts        = 2,
			ListID          = e [f],
			LearningContext = e [f + 1]
		}
	end
	a.params [3] [#a.params [3] + 1] = {
		ListID            = e [f],
		QuestionsAnswered = (#g) * 2,
		TimeTaken         = z,
		TimeTakenMS       = json.null,
		LearningContext   = e [f + 1]
	}
	gg [#gg + 1] = e [f]
	gg [#gg + 1] = e [f + 1]
	y = y + z
end
a.params [4] = y

a = json.stringify (a)
print (a, #a)
print (json.stringify (gg))

-- Editing nz.co.LanguagePerfect.Services.PortalsAsync.App.AppServicesPortal.StoreActivityUsageData3
-- Module

local a = [[]]
      a = json.parse (a)
local b = ''
      b = json.parse (b)

local c, e, y, gg = a.params [2] [1].UserID, {}, 0, {}

for d, _ in pairs (b) do
	e [#e + 1] = d
	e [#e + 1] = 0
	e [#e + 1] = d
	e [#e + 1] = 1
end

a.params [2] = {}
a.params [3] = {}

for f = 1, #e / 2 , 2 do
	local g = b [''..e [f]]
	local z = 0
	for h = 1, #g do
		local t, tt = math.random (6, 11), math.random (6, 11)
		z = z + t + tt
		a.params [2] [#a.params [2] + 1] = {
			UserID          = c,
			QuestionID      = g [h],
			Time            = t,
			TimeMS          = json.null,
			Correct         = true,
			Attempts        = 1,
			ListID          = e [f],
			LearningContext = e [f + 1]
		}
		a.params [2] [#a.params [2] + 1] = {
			UserID          = c,
			QuestionID      = g [h],
			Time            = tt,
			TimeMS          = json.null,
			Correct         = true,
			Attempts        = 2,
			ListID          = e [f],
			LearningContext = e [f + 1]
		}
	end
	a.params [3] [#a.params [3] + 1] = {
		ListID            = e [f],
		QuestionsAnswered = (#g) * 2,
		TimeTaken         = z,
		TimeTakenMS       = json.null,
		LearningContext   = e [f + 1]
	}
	gg [#gg + 1] = e [f]
	gg [#gg + 1] = e [f + 1]
	y = y + z
end
a.params [4] = y

a = json.stringify (a)
print (a, #a)
print (json.stringify (gg))

-- Editing nz.co.LanguagePerfect.Services.PortalsAsync.App.AppServicesPortal.StoreActivityProgress2
-- Single & Module

local a = [[]]
      a = json.parse (a)
local b = ''
      b = json.parse (b)
local c = ''
      c = json.parse (c)

a.params [5] = {}

local d = 1
for e = 1, #c / 2, 2 do
	local f = b [''..c [e]]
	for g = 1, #f do
		a.params [5] [#a.params [5] + 1] = {
			TranslationID        = f [g],
			TranslationDirection = c [e + 1],
			NewNumberRight       = 2,
			NewNumberWrong       = 0,
			NewData              = 98
		}
	end
	d = d + 1
end

a = json.stringify (a)
print (a, #a)

-- Edit
