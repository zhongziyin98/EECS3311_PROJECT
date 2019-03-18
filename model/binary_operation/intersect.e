note
	description: "Summary description for {INTERSECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERSECT
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_intersect(current)
	end

end
