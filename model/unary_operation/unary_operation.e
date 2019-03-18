note
	description: "Summary description for {UNARY_OPERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	UNARY_OPERATION
inherit
	EXPRESSION
	COMPOSITION

feature {VISITOR} -- children

	right: detachable EXPRESSION
	do
		if children.count>=1 then
			Result:=children.at (1)
		else
			Result:=void
		end
	end

feature -- command

	add_expression(e: EXPRESSION)
	do
		-- inorder traversal: (left), current, right
		if children.is_empty then
			children.force (e)
		else -- has a not-full subtree
			check attached {COMPOSITION} right as r then -- then it must not be a const
				check r.can_add then
					r.add_expression(e)
				end
			end
		end
	end

invariant
	unary_op:
		children.count<=1

end
