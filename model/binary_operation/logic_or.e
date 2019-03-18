note
	description: "Summary description for {LOGIC_OR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGIC_OR
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_logic_or(current)
	end

end
