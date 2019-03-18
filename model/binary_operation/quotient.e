note
	description: "Summary description for {QUOTIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QUOTIENT
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_quotient(current)
	end

end
