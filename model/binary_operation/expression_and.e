note
	description: "Summary description for {LOGIC_AND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGIC_AND
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_logic_and(current)
	end

end
