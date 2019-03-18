note
	description: "Summary description for {COMPOSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMPOSITION
	inherit
		EXPRESSION

feature {VISITOR}

	children: LINKED_LIST[EXPRESSION]

feature -- init

	make
	do
		create children.make
	end

feature {ETF_MODEL, COMPOSITION}
	add_expression(e:EXPRESSION) -- add e to current expression. NOT a copy of e.
	require
		can_add: can_add
	deferred end


end
