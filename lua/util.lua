
local pq = {}

pq.printt = ''
pq.printt = function (a, t) -- k, k [{}] = true, if k [{}] then return end
	t = t or 0
	for b, c in pairs (a) do
		print (t ~= 0 and ('	'):rep (t) or '', b, type (c) ~= 'table' and (type (c) == 'number' and string.format ("%.0f", c) or c) or '')
		if type (c) == 'table' then
			pq.printt (c, t + 1)
		end
	end
end

pq.httpi = function (a, b)
	if a:match (b) then return false end
	print (('Incorrect http request.\n'..
            '-----------------------\n'..
            'Expected:	%s          \n'..
            'Got:		%s          \n'
           ):format (b, a:match '%?target=.*%.(.*) HTTP' or 'HTTP Response'))
	return true
end

pq.b = function (a) return function () return a end end
pq.rt = pq.b (true )
pq.rf = pq.b (false)
pq.rn = pq.b (nil  )

pq.an = function (a) return a..'\n' end

pq.todo = {
	[[Change b-b to list based.]],
	[[Change c-b to list based.]],
	[[Make it so content-length actually changes.]],
	[[More OOP???]], 
	[[b-# and c-# turned into 1 func with diff calling.]],
	[[b.result.StructuredActivities]]
}

return pq
