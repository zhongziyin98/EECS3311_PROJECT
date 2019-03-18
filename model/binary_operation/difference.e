note
	description: "Summary description for {DIFFERENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DIFFERENCE
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_difference(current)
	end

end
