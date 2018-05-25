
-- C:/lua/bin/lua.exe "C:/lua/bin/test.lua"
-- cd ep; lua test.lua
      _pq = _pq or {}
local _pq = _pq
local  pq = {}

-- pq.luce = require 'luce' () -- maybe? lol
pq.json = require 'json'    -- replace this third party trash
pq.bon  = require 'bon'     -- wish i could replace json with bon :(((((
pq.com  = require 'command'
pq.util = require 'util'
pq.file = require 'file'
pq.oop  = require 'oop'

pq.com.add ('quit', 'Quit', 'Ends session.', pq.util.rt, false)


pq.com.add ('a', 'a', 'GetAppDataForActivitySelection\nScrape Collections', function ()
	local a = pq.file.read 'in'
	
	if pq.util.httpi (a, 'GetAppDataForActivitySelection') then return end
	
	local b       = pq.json.parse (a:match '({.*})')
	local c, d, e = b.result.Collections.Generic, {}, {}
	
	for f = 1, #c do
		print (('Importing:	%s'):format (c [f].ID))
		d [c [f].ID] = {}
		for g = 1, #c [f].Words do
			d [c [f].ID] [g] = c [f].Words [g]
			e [c [f].Words [g]] = c [f].ID
		end
	end
	
	--local f = b.result.StructuredActivities

	pq.file.writeb ('hold'   , d)
	pq.file.writeb ('special', e)

end, true)

pq.com.add ('b-a', 'b-a', 'StoreActivityUsageData3\nSelected', function ()
	local a = pq.file.read 'in'

	if pq.util.httpi (a, 'StoreActivityUsageData3') then return end

	local b, c = pq.json.parse (a:match '({.*})'), pq.file.readb 'hold'
	local d, e, f, g = b.params [2] [1].UserID, {}, 0, {}
	
	for h = 1, #b.params [3] do
		e [#e + 1] = b.params [3] [h].ListID
		e [#e + 1] = b.params [3] [h].LearningContext
	end

	b.params [2] = pq.oop.params ()
	b.params [3] = pq.oop.params ()

	for h = 1, #e / 2 , 2 do
		local i, j, k, l = c [''..e [h]], 0, e [h], e[h + 1]
		local n, o = b.params [2], b.params [3]
		for m = 1, #i do
			n:Add (pq.oop.question ()
				:ID       (d, i [m])
				:Time     (math.random (6, 11), nil)
				:Question (true, 1)
				:List     (k, l)
				:Finish   ())
			n:Add (pq.oop.question ()
				:ID       (d, i [m])
				:Time     (math.random (6, 11), nil)
				:Question (true, 2)
				:List     (k, l)
				:Finish   ())
			j = j + n.q [#n.q].Time + n.q [#n.q - 1].Time
		end
		o:Add (pq.oop.list ()
			:Question ((#i) * 2)
			:Time     (j , nil)
			:List     (k, l)
			:Finish   ())
		g [#g + 1] = k
		g [#g + 1] = l
		f = f + j
	end
	b.params [2] = b.params [2]:Finish ()
	b.params [3] = b.params [3]:Finish ()
	b.params [4] = f

	b = pq.json.stringify (b)
	a = a:gsub ('Content-Length: %d+\n', ('Content-Length: %d\n'):format (#b)):gsub ('{.*}', b)

	pq.file.write ('out', a)
end, true)
pq.com.add ('b-b', 'b-b', 'StoreActivityUsageData3\nModule'  , function ()
	local a = pq.file.read 'in'

	if pq.util.httpi (a, 'StoreActivityUsageData3') then return end

	local b, c = pq.json.parse (a:match '({.*})'), pq.file.readb 'hold'
	local d, e, f, g = b.params [2] [1].UserID, {}, 0, {}

	for z, _ in pairs (c) do
		e [#e + 1] = z
		e [#e + 1] = 0
		e [#e + 1] = z
		e [#e + 1] = 1
	end

	b.params [2] = pq.oop.params ()
	b.params [3] = pq.oop.params ()

	for h = 1, #e / 2 , 2 do
		local i, j, k, l = c [''..e [h]], 0, e [h], e[h + 1]
		local n, o = b.params [2], b.params [3]
		for m = 1, #i do
			n:Add (pq.oop.question ()
				:ID       (d, i [m])
				:Time     (math.random (6, 11), nil)
				:Question (true, 1)
				:List     (k, l)
				:Finish   ())
			n:Add (pq.oop.question ()
				:ID       (d, i [m])
				:Time     (math.random (6, 11), nil)
				:Question (true, 2)
				:List     (k, l)
				:Finish   ())
			j = j + n.q [#n.q].Time + n.q [#n.q - 1].Time
		end
		o:Add (pq.oop.list ()
			:Question ((#i) * 2)
			:Time     (j , nil)
			:List     (k, l)
			:Finish   ())
		g [#g + 1] = k
		g [#g + 1] = l
		f = f + j
	end
	b.params [2] = b.params [2]:Finish ()
	b.params [3] = b.params [3]:Finish ()
	b.params [4] = f

	b = pq.json.stringify (b)
	a = a:gsub ('Content-Length: %d+\n', ('Content-Length: %d\n'):format (#b)):gsub ('{.*}', b)

	pq.file.write ('out', a)
end, true)

pq.com.add ('c-a', 'c-a', 'StoreActivityProgress2\nSelected', function ()
	local _f = pq.file.read 'in'

	if pq.util.httpi (_f, 'StoreActivityProgress2') then return end

	local data, mod_data, spc_data = pq.json.parse (_f:match '({.*})'), pq.file.readb 'hold', pq.file.readb 'special'

	local trans_dir, list = data.params [5] [1].TranslationDirection, mod_data [spc_data [ data.params [5] [1].TranslationID]]

	data.params [5] = pq.oop.params ()

	for a = 1, #list do
		data.params [5]:Add (pq.oop.activity ()
			:Translation (list [a], trans_dir)
			:NewData     (98, 2, 0)
			:Finish      ())
	end

	data.params [5] = data.params [5]:Finish ()

	data = pq.json.stringify (data)

	_f = _f:gsub ('Content-Length: %d+\n', ('Content-Length: %s\n'):format (#data)):gsub ('{.*}', data)

	pq.file.write ('out', _f)
end, true)
                                                                       
pq.com.add ('c-b', 'c-b', 'StoreActivityProgress2\nSelected', function ()
	local _f = pq.file.read 'in'

	if pq.util.httpi (_f, 'StoreActivityProgress2') then return end

	local data, mod_data, spc_data = pq.json.parse (_f:match '({.*})'), pq.file.readb 'hold', pq.file.readb 'special'

	local trans_dir, list = data.params [5] [1].TranslationDirection, mod_data [spc_data [ data.params [5] [1].TranslationID]]

	data.params [5] = pq.oop.params ()

	for a = 1, #list do
		data.params [5]:Add (pq.oop.activity ()
			:Translation (list [a], trans_dir)
			:NewData     (98, 2, 0)
			:Finish      ())
	end

	data.params [5] = data.params [5]:Finish ()

	data = pq.json.stringify (data)

	_f = _f:gsub ('Content-Length: %d+\n', ('Content-Length: %s\n'):format (#data)):gsub ('{.*}', data)

	pq.file.write ('out', _f)
end, true)

local F = pq.util.an

print (F[[====================================]]..
       F[[|           _ __    __ _           |]]..
       F[[|          | '_ \  / _' |          |]]..
       F[[|          | |_) || (_| |          |]]..
       F[[|          | .__/  \__. |          |]]..
       F[[|          | |        | |          |]]..
       F[[|          |_|        |_|          |]]..
       F[[====================================]]..
       F[[| Commands:                         ]]..
      (F[[|	%s|		%s]]):rep (pq.com.count ()):format (pq.com.unpack ())..
       F[[====================================]]..
       F[[| Toodle Doo:                       ]]..
      (F[[|	%s        ]]):rep (#pq.util.todo):format (table.unpack (pq.util.todo))..
       F[[====================================]])
while true do
	local a = pq.com.getall () [io.read ():lower ()]
          a = a and a [3] or pq.com.ic

	if a () then break end
end
