note
	description: "Summary description for {PRODUCT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRODUCT
inherit
	UNARY_OPERATION

create
	make

feature
	accept(v: VISITOR)
	do
		v.visit_product (current)
	end

end
