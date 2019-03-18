note
	description: "Summary description for {TIMES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TIMES
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_times(current)
	end

end
