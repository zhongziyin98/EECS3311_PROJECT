note
	description: "Summary description for {INTEGER_CONSTANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTEGER_CONSTANT
inherit
	EXPRESSION

create
	make

feature
	make(i: INTEGER)
	require
		non_negative: i>=0
	do
		value:=i
	end

feature

	value: INTEGER


feature -- visit
	accept(v:VISITOR)
	do
		v.visit_integer_constant(current)
	end

invariant
	non_negative:
		value>=0

end
