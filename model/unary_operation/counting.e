note
	description: "Summary description for {COUNTING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COUNTING
inherit
	UNARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_counting (current)
	end

end
