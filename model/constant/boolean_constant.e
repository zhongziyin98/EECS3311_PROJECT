note
	description: "Summary description for {BOOLEAN_CONSTANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOOLEAN_CONSTANT
inherit
	EXPRESSION

create
	make

feature
	make(b: BOOLEAN)
	do
		value:=b
	end

feature

	value: BOOLEAN

feature -- ops

	accept(v:VISITOR)
	do
		v.visit_boolean_constant(current)
	end



end
