note
	description: "Summary description for {MINUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MINUS
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_minus(current)
	end

end
