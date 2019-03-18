note
	description: "Summary description for {LOGIC_IMPLIES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGIC_IMPLIES
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_logic_implies(current)
	end

end
