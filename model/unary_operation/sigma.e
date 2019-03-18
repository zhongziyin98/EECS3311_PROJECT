note
	description: "Summary description for {SIGMA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIGMA
inherit
	UNARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_sigma (current)
	end

end
