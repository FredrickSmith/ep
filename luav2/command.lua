
local pq     = {}
      pq.all = {}
      pq.c   = 0

pq.getall = function () return pq.all end

pq.detour = function (a, b)
	return function (...)
		return b (a, ...)
	end
end

pq.add = function (a, b, c, d, e) -- command, name, desc, func, print
	if pq.all [a] then return print (('Command "%s" already exist\'s'):format (a)) end
	local f = d
	c = c:gsub ('\n', "\n|			")
	d = e and pq.detour (d,
		function (a, ...)
			print (('Starting: %s'):format (b))
			local c = a (...)
			print (('Finished: %s'):format (b))
			return c
		end) or d
	pq.all [a] = {b, c, d}
	pq.c = pq.c + 1
end
pq.remove = function (a)
	pq.all [a] = nil
	pq.c = pq.c - 1
end

pq.pbk = function (a, b)local c={}for d in pairs(a) do table.insert(c,d)end table.sort(c,b)local e=0local f=function()e=e+1if c[e]==nil then return nil else return c[e],a[c[e]]end end return f end
pq.unpack = function ()
	local a = {}
	for b, c in pq.pbk (pq.getall ()) do
		a [#a + 1] = b..'\n'
		a [#a + 1] = c [2]
	end
	return table.unpack (a)
end
pq.count = function () return pq.c end

pq.ic = function () print ('Invalid command.') return nil end

return pq
