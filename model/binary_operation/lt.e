note
	description: "Summary description for {LT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LT
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_lt(current)
	end

end
