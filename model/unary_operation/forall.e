note
	description: "Summary description for {FORALL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FORALL
inherit
	UNARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_forall (current)
	end

end
