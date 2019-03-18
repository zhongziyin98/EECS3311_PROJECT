note
	description: "Summary description for {NEGATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEGATION
inherit
	UNARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_negation (current)
	end

end
