note
	description: "Summary description for {GT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GT
inherit
	BINARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_gt(current)
	end

end
