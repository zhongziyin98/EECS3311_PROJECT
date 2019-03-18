note
	description: "Summary description for {LOGIC_XOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGIC_XOR
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_logic_xor(current)
	end

end
