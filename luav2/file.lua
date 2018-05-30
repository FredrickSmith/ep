
local pq = {}

local json = require 'json'
local bon  = require 'bon'

pq.read = function (a)
	      a = assert (io.open (a, 'rb'))
	local b = a:read '*a'
	a:close ()
	return b
end
pq.write = function (a, b)
	io.open (a, 'wb'):write (b):close ()
end

pq.readj  = function (a   ) return json.parse (pq.read (a))  end
pq.writej = function (a, b) pq.write (a, json.stringify (b)) end

pq.readb  = function (a   ) return bon.deserialize (pq.read (a)) end
pq.writeb = function (a, b) pq.write (a, bon.serialize (b))      end

return pq
