
-- C:/lua/bin/lua.exe "C:/lua/bin/test.lua"
      _pq = _pq or {}
local _pq = _pq
local  pq = {}

-- pq.luce = require 'luce' () -- maybe? lol
pq.json = require 'json'    -- replace this third party trash
pq.com  = require 'command'
pq.util = require 'util'
pq.file = require 'file'
pq.oop  = require 'oop'

pq.com.add ('quit', 'Quit', 'Ends session.', pq.util.rt, false)


pq.com.add ('a', 'a', 'GetAppDataForActivitySelection\nScrape Collections', function ()
	local a, b = pq.json.parse (pq.file.read 'in':match '({.*})'), {}
	local c = a.result.Collections.Generic
	
	for d = 1, #c do
		print (('Importing:	%s'):format (c [d].ID))
		b [c [d].ID] = {}
		for e = 1, #c [d].Words do
			b [c [d].ID] [e] = c [d].Words [e]
		end
	end
	
	local d = a.result.StructuredActivities

	pq.file.write ('hold', pq.json.stringify (b))
end, true)

pq.com.add ('b-a', 'b-a', 'StoreActivityUsageData3\nSelected', function ()
	local a = pq.file.read 'in'
	if not a:match 'StoreActivityUsageData3' then
		pq.util.httpi ('StoreActivityUsageData3', a)
		return
	end

	local b, c = pq.json.parse (a:match '({.*})'), pq.json.parse (pq.file.read 'hold')
	local d, e, f, g = b.params [2] [1].UserID, {}, 0, {}
	
	for h = 1, #b.params [3] do
		e [#e + 1] = b.params [3] [h].ListID
		e [#e + 1] = b.params [3] [h].LearningContext
	end

	b.params [2] = {}
	b.params [3] = {}

	for h = 1, #e / 2 , 2 do
		local i, j, k, l = c [''..e [h]], 0, e [h], e[h + 1]
		for m = 1, #i do
			b.params [2] [#b.params [2] + 1] = pq.oop.question ()
				:ID       (d, i [m])
				:Time     (math.random (6, 11), nil)
				:Question (true, 1)
				:List     (k, l)
				:Finish   ()
			b.params [2] [#b.params [2] + 1] = pq.oop.question ()
				:ID       (d, i [m])
				:Time     (math.random (6, 11), nil)
				:Question (true, 2)
				:List     (k, l)
				:Finish   ()
			j = j + b.params [2] [#b.params [2]].Time + b.params [2] [#b.params [2] - 1].Time
		end
		b.params [3] [h] = pq.oop.list ()
			:Question ((#i) * 2)
			:Time     (j , nil)
			:List     (k, l)
			:Finish   ()
		g [#g + 1] = k
		g [#g + 1] = l
		f = f + j
	end
	b.params [4] = f

	pq.file.write ('special', pq.json.stringify (g))

	b = pq.json.stringify (b)
	a = a:gsub ('Content-Length: %d+\n', ('Content-Length: %d\n'):format (#b)):gsub ('{.*}', b)

	pq.file.write ('out', a)
end, true)
pq.com.add ('b-b', 'b-b', 'StoreActivityUsageData3\nModule'  , function ()
	local a = pq.file.read 'in'
	if not a:match 'StoreActivityUsageData3' then
		pq.util.httpi ('StoreActivityUsageData3', a)
		return
	end

	local b, c = pq.json.parse (a:match '({.*})'), pq.json.parse (pq.file.read 'hold')
	local d, e, f, g = b.params [2] [1].UserID, {}, 0, {}
	
	for z, _ in pairs (c) do
		e [#e + 1] = z
		e [#e + 1] = 0
		e [#e + 1] = z
		e [#e + 1] = 1
	end

	b.params [2] = {}
	b.params [3] = {}

	for h = 1, #e / 2 , 2 do
		local i, j, k, l = c [''..e [h]], 0, e [h], e[h + 1]
		for m = 1, #i do
			b.params [2] [#b.params [2] + 1] = pq.oop.question ()
				:ID       (d, i [m])
				:Time     (math.random (6, 11), nil)
				:Question (true, 1)
				:List     (k, l)
				:Finish   ()
			b.params [2] [#b.params [2] + 1] = pq.oop.question ()
				:ID       (d, i [m])
				:Time     (math.random (6, 11), nil)
				:Question (true, 2)
				:List     (k, l)
				:Finish   ()
			j = j + b.params [2] [#b.params [2]].Time + b.params [2] [#b.params [2] - 1].Time
		end
		b.params [3] [h] = pq.oop.list ()
			:Question ((#i) * 2)
			:Time     (j , nil)
			:List     (k, l)
			:Finish   ()
		g [#g + 1] = k
		g [#g + 1] = l
		f = f + j
	end
	b.params [4] = f

	pq.file.write ('special', pq.json.stringify (g))

	b = pq.json.stringify (b)
	a = a:gsub ('Content-Length: %d+\n', ('Content-Length: %d\n'):format (#b)):gsub ('{.*}', b)

	pq.file.write ('out', a)
end, true)

pq.com.add ('c-a', 'c-a', 'StoreActivityProgress2\nSelected & Module', function ()
	local _f = pq.file.read 'in'
	if not _f:match 'StoreActivityProgress2' then
		pq.util.httpi ('StoreActivityProgress2', _f)
		return
	end

	local data, saved_data, old_data = pq.json.parse (_f:match '({.*})'), pq.json.parse (pq.file.read 'hold'), pq.json.parse (pq.file.read 'special')

	data.params [5] = {}

	for f = 1, #old_data / 2, 2 do
		local g = saved_data [''..old_data [f]]
		for z, x in pairs (g) do print (z, x) end
		for h = 1, #g do
			data.params [5] [#data.params [5] + 1] = pq.oop.activity ()
				:Translation (g [h], old_data [f + 1])
				:NewData     (98, 2, 0)
				:Finish      ()
		end
	end
	for z = 1, #data.params [5] do
		print (z, data.params [5] [z].TranslationID)
	end
	data = pq.json.stringify (data)
	print (data)
	_f = _f:gsub ('Content-Length: %d+\n', ('Content-Length: %s\n'):format (#data)):gsub ('{.*}', data)

	pq.file.write ('out', _f)
end, true)


print ('====================================\n' ..
       '|           _ __    __ _           |\n' ..
       "|          | '_ \\  / _' |          |\n"..
       '|          | |_) || (_| |          |\n' ..
       '|          | .__/  \\__. |          |\n'..
       '|          | |        | |          |\n' ..
       '|          |_|        |_|          |\n' ..
       '====================================\n' ..
       '| Commands:                         \n' ..
      ('|	%s\n|		%s\n'):rep (pq.com.count ()):format (pq.com.unpack ())..
       '====================================\n')

while true do
	local a = pq.com.getall () [io.read ():lower ()]
          a = a and a [3] or pq.com.ic

	if a () then break end
end
