note
	description: "Summary description for {UNION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNION
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_union(current)
	end

end
