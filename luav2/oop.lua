 
local _pq = {}

_pq.base_Table     = function ( ) return {           } end
_pq.base_Metatable = function (a) return {__index = a} end

_pq.object = function (a, b, c)
	a = a or _pq.base_Table ()
	b = c and b or _pq.base_Metatable (b or a)
	setmetatable (a, b)
	return a
end

do
	local pq   = {}

	function pq:ID (a, b)
 		self.q.UserID     = a
		self.q.QuestionID = b
		return self
	end
	function pq:Time (a, b)
		self.q.Time   = a
		self.q.TimeMS = b
		return self
	end
	function pq:Question (a, b)
		self.q.Correct  = a
		self.q.Attempts = b
		return self
	end
	function pq:List (a, b)
		self.q.ListID          = a
		self.q.LearningContext = b
		return self
	end
	function pq:Finish ()
		local a = self.q
		self = nil
		return a
	end

	_pq.question = function ()
		return _pq.object ({q = {}}, pq)
	end
end

do
	local pq   = {}

	function pq:Question (a)
		self.q.QuestionsAnswered = a
		return self
	end
	function pq:Time (a, b)
		self.q.TimeTaken   = a
		self.q.TimeTakenMS = b
		return self
	end
	function pq:List (a, b)
		self.q.ListID          = a
		self.q.LearningContext = b
		return self
	end
	function pq:Finish ()
		local a = self.q
		self = nil
		return a
	end

	_pq.list = function ()
		return _pq.object ({q = {}}, pq)
	end
end

do
	local pq   = {}

	function pq:Translation (a, b)
		self.q.TranslationID        = a
		self.q.TranslationDirection = b
		return self
	end
	function pq:NewData (a, b, c)
		self.q.NewData        = a
		self.q.NewNumberRight = b
		self.q.NewNumberWrong = c
		return self
	end
	function pq:Finish ()
		local a = self.q
		self = nil
		return a
	end

	_pq.activity = function ()
		return _pq.object ({q = {}}, pq)
	end
end

do
	local pq   = {}

	function pq:Add (a)
		self.q [#self.q + 1] = a
		return self
	end
	function pq:Finish ()
		local a = self.q
		self = nil
		return a
	end

	_pq.params = function ()
		return _pq.object ({q = {}}, pq)
	end
end

return _pq
