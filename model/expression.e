note
	description: "Summary description for {EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXPRESSION

feature -- ops

	accept(v: VISITOR)
	deferred
	end

feature -- tree structure

	can_add: BOOLEAN
	local
		a: ANALYSIS
	do
		create a.make
		current.accept (a)
		Result := a.voided
	end

end
