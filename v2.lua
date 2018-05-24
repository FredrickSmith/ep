
-- C:/lua/bin/lua.exe "C:/lua/bin/test.lua"
      _pq = _pq or {}
local _pq = _pq
local  pq = {}

-- pq.luce = require 'luce' () -- maybe? lol
pq.json = require 'json'    -- replace this third party trash
pq.com  = require 'command'
pq.util = require 'util'
pq.file = require 'file'

pq.com.add ('quit', 'Quit', 'Ends session.', pq.util.rt, false)


pq.com.add ('a', 'a', 'GetAppDataForActivitySelection\nScrape Collections', function ()
	local a, b = pq.json.parse (pq.file.read 'in.txt':match '({.*})'), {}
	local c = a.result.Collections.Generic
	
	for d = 1, #c do
		print (('Importing:	%s'):format (c [d].ID))
		b [c [d].ID] = {}
		for e = 1, #c [d].Words do
			b [c [d].ID] [e] = c [d].Words [e]
		end
	end

	pq.file.write ('hold.txt', pq.json.stringify (b))
end, true)

pq.com.add ('b-a', 'b-a', 'StoreActivityUsageData3\nSelected', function ()
	local a = pq.file.read 'in.txt'
	if not a:match 'StoreActivityUsageData3' then
		pq.util.httpi ('StoreActivityUsageData3', a)
		return
	end

	local b, c = pq.json.parse (a:match '({.*})'), pq.json.parse (pq.file.read 'hold.txt')
	local d, e, f, g = b.params [2] [1].UserID, {}, 0, {}
	
	for h = 1, #b.params [3] do
		e [#e + 1] = b.params [3] [h].ListID
		e [#e + 1] = b.params [3] [h].LearningContext
	end

	b.params [2] = {}
	b.params [3] = {}

	for h = 1, #e / 2 , 2 do
		local i = c [''..e [h]]
		local j = 0
		for k = 1, #i do
			b.params [2] [#b.params [2] + 1] = {
				UserID          = d,
				QuestionID      = i [k],
				Time            = math.random (6, 11),
				TimeMS          = nil,
				Correct         = true,
				Attempts        = 1,
				ListID          = e [h],
				LearningContext = e [h + 1]
			}
			b.params [2] [#b.params [2] + 1] = {
				UserID          = d,
				QuestionID      = i [k],
				Time            = math.random (6, 11),
				TimeMS          = nil,
				Correct         = true,
				Attempts        = 2,
				ListID          = e [h],
				LearningContext = e [h + 1]
			}
			j = j + b.params [2] [#b.params [2]].Time + b.params [2] [#b.params [2] - 1].Time
		end
		b.params [3] [#b.params [3] + 1] = {
			ListID            = e [h],
			QuestionsAnswered = (#i) * 2,
			TimeTaken         = j,
			TimeTakenMS       = nil,
			LearningContext   = e [h + 1]
		}
		g [#g + 1] = e [h]
		g [#g + 1] = e [h + 1]
		f = f + j
	end
	b.params [4] = f

	pq.file.write ('special.txt', pq.json.stringify (g))

	b = pq.json.stringify (b)
	a = a:gsub ('Content-Length: %d+\n', ('Content-Length: %d\n'):format (#b)):gsub ('{.*}', b)

	pq.file.write ('out.txt', a)
end, true)
pq.com.add ('b-b', 'b-b', 'StoreActivityUsageData3\nModule'  , function ()

end, true)

pq.com.add ('c-a', 'c-a', 'StoreActivityProgress2\nSelected & Module', function ()
	local a = pq.file.read 'in.txt'
	if not a:match 'StoreActivityProgress2' then
		pq.util.httpi ('StoreActivityProgress2', a)
		return
	end

	local b, c, d = pq.json.parse (a:match '({.*})'), pq.json.parse (pq.file.read 'hold.txt'), pq.json.parse (pq.file.read 'special.txt')

	b.params [5] = {}

	local e = 1
	for f = 1, #d / 2, 2 do
		local g = c [''..d [f]]
		for h = 1, #g do
			b.params [5] [#b.params [5] + 1] = {
				TranslationID        = g [h],
				TranslationDirection = d [f + 1],
				NewNumberRight       = 2,
				NewNumberWrong       = 0,
				NewData              = 98
			}
		end
		e = e + 1
	end

	b = pq.json.stringify (b)
	a = a:gsub ('^Content-Length: %d+$', ('Content-Length: %s\n'):format (#b)):gsub ('{.*}', b)

	pq.file.write ('out.txt', a)
end, true)


print ('====================================\n' ..
       '|    Language/Education Perfect    |\n' ..
       '|        HTTP Request Editor       |\n' ..
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
