note
	description: "Summary description for {MOD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOD
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_mod(current)
	end

end
