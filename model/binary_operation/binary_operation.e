note
	description: "Summary description for {BINARY_OPERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BINARY_OPERATION
inherit
	EXPRESSION
	COMPOSITION

feature {VISITOR} -- children

	left: detachable EXPRESSION
	do
		if children.count>=1 then
			Result:=children.at (1)
		else
			Result:=void
		end
	end


	right: detachable EXPRESSION
	do
		if children.count>=2 then
			Result:=children.at (2)
		else
			Result:=void
		end
	end

feature -- command
	add_expression(e:EXPRESSION)
	do
		-- inorder traversal: left, current, right

		if children.is_empty then -- empty left
			children.force (e)
		else
			check attached left as l then
				if l.can_add then -- has a not-full left subtree
					check attached {COMPOSITION} l as ll then -- then left must not be a const
						ll.add_expression(e)
					end
				else
					if children.count = 1 then -- has a full left subtree and empty right
						children.force (e)
					else
						check attached right as r then
							check r.can_add then -- has a full left subtree and a not-full right subtree
								check attached {COMPOSITION} r as rr then -- then right must not be a const
									rr.add_expression(e)
								end
							end
						end
					end
				end
			end
		end



	end

invariant
	binary_op:
		children.count <= 2

end
