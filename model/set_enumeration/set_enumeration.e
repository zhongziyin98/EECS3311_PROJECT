note
	description: "Summary description for {SET_ENUMERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SET_ENUMERATION
inherit
	EXPRESSION
	COMPOSITION
	ITERABLE[EXPRESSION]

create
	make

feature -- attr

	closed: BOOLEAN -- auto initialized false

feature
	close
	do
		closed:=True
	end

	new_cursor: ITERATION_CURSOR[EXPRESSION]
	do
		Result:=children.new_cursor
	end

	count: INTEGER_32
	do
		Result:=children.count
	end
	

	add_expression(e:EXPRESSION)
	local
		added: BOOLEAN
		c: ITERATION_CURSOR[EXPRESSION]
	do
		if children.is_empty then -- empty set yet
			children.force (e)
		elseif -- all children are full
			across children as exp all
				not exp.item.can_add
			end
		then
			check not closed then -- add to current
				children.force (e)
			end
		else
			from
				added := false
				c := children.new_cursor
			until
				added = true
			loop
				check not c.after then
					if c.item.can_add then -- subtree is not full
						check attached {COMPOSITION} c.item as com then -- then it must not be a const
							com.add_expression(e)
							added := true
						end
					else
						c.forth
					end
				end
			end


		end

	end

feature -- visit
	accept(v:VISITOR)
	do
		v.visit_set_enumeration(current)
	end

end
