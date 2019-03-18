note
	description: "Summary description for {ANALYSIS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANALYSIS

inherit
	VISITOR

create
	make, make_sub

feature
	make
	do
		type := ""
		type_correct := true
	end

feature
	type: STRING
	type_correct: BOOLEAN

feature {NONE}
	visit_binary_operation(e: BINARY_OPERATION; require_left, require_right: like type)
	local
		a1, a2: ANALYSIS
	do
		create a1.make_sub (voided)
		visit_node(e.left, a1)

		create a2.make_sub (voided)
		visit_node(e.right, a2)

		if type_correct and (not voided) then
			if a1.type ~ require_left and a2.type ~ require_right then
				type_correct := true
			else
				type_correct := false
			end
		end
	end

	visit_unary_operation(e: UNARY_OPERATION; require_right: like type)
	local
		a:ANALYSIS
	do
		create a.make_sub (voided)
		visit_node(e.right, a)

		if type_correct and (not voided) then
			if a.type ~ require_right then
				type_correct := true
			else
				type_correct := false
			end
		end
	end

	visit_set(e: UNARY_OPERATION; require_element: like type) -- unary on set
	local
		a:ANALYSIS
		ll: LINKED_LIST[like type]
	do
		create ll.make
		if not attached e.right then
			voided := true
		else
			create a.make
			check attached e.right as r then
				r.accept(a)
			end
			if a.type /~ "set" then
				type_correct := false
			end

			if type_correct and not voided then
				check attached {SET_ENUMERATION} e.right as se then
					across se as ex loop
						create a.make_sub (voided)
						visit_node(ex.item, a)

						ll.force (a.type)
					end
					if not se.closed then
						voided := true
					end
				end
			end

		end


		if type_correct and (not voided) then
			if
				across ll as tt all
					tt.item ~ require_element
				end
			then
				type_correct := true
			else
				type_correct := false
			end
		end

	end

	visit_node(node: detachable EXPRESSION; a: like current)
	do
		if attached node as n then
			n.accept (a)
			if a.voided then
				voided:=True
			end
			if not a.type_correct then
				type_correct := false
			end
		else
			voided:=True
		end
	end


feature
	visit_integer_constant(e:INTEGER_CONSTANT)
	do
		type := "integer"
		type_correct := true
	end

	visit_boolean_constant(e: BOOLEAN_CONSTANT)
	do
		type := "boolean"
		type_correct := true
	end


feature -- binary ops
	visit_plus(e:PLUS)
	do
		type := "integer"
		visit_binary_operation(e, "integer", "integer")
	end

	visit_minus(e: MINUS)
	do
		type := "integer"
		visit_binary_operation(e, "integer", "integer")
	end

	visit_times(e: TIMES)
	do
		type := "integer"
		visit_binary_operation(e, "integer", "integer")
	end

	visit_quotient(e: QUOTIENT)
	do
		type := "integer"
		visit_binary_operation(e, "integer", "integer")
	end

	visit_mod(e: MOD)
	do
		type := "integer"
		visit_binary_operation(e, "integer", "integer")
	end

	visit_logic_and(e: LOGIC_AND)
	do
		type := "boolean"
		visit_binary_operation(e, "boolean", "boolean")
	end

	visit_logic_or(e: LOGIC_OR)
	do
		type := "boolean"
		visit_binary_operation(e, "boolean", "boolean")
	end

	visit_logic_xor(e: LOGIC_XOR)
	do
		type := "boolean"
		visit_binary_operation(e, "boolean", "boolean")
	end

	visit_logic_implies(e: LOGIC_IMPLIES)
	do
		type := "boolean"
		visit_binary_operation(e, "boolean", "boolean")
	end

	visit_logic_equal(e: LOGIC_EQUAL)
	local
		a1, a2: ANALYSIS
	do
		type := "boolean"

		create a1.make_sub (voided)
		visit_node(e.left, a1)

		create a2.make_sub (voided)
		visit_node(e.right, a2)

		if type_correct and (not voided) then
			if (a1.type ~ a2.type) and a1.type /~ "" then
				type_correct := true
			else
				type_correct := false
			end
		end
	end

	visit_gt(e: GT)
	do
		type := "boolean"
		visit_binary_operation(e, "integer", "integer")
	end

	visit_lt(e: LT)
	do
		type := "boolean"
		visit_binary_operation(e, "integer", "integer")
	end

	visit_union(e: UNION)
	do
		type := "set"
		visit_binary_operation(e, "set", "set")
	end

	visit_intersect(e: INTERSECT)
	do
		type := "set"
		visit_binary_operation(e, "set", "set")
	end

	visit_difference(e: DIFFERENCE)
	do
		type := "set"
		visit_binary_operation(e, "set", "set")
	end

feature -- unary ops
	visit_negative(e: NEGATIVE)
	do
		type := "integer"
		visit_unary_operation(e, "integer")
	end

	visit_negation(e: NEGATION)
	do
		type := "boolean"
		visit_unary_operation(e, "boolean")
	end

feature -- unary ops on set
	visit_sigma(e: SIGMA)
	do
		type := "integer"
		visit_set(e, "integer")
	end

	visit_product(e: PRODUCT)
	do
		type := "integer"
		visit_set(e, "integer")
	end

	visit_forall(e: FORALL)
	do
		type := "boolean"
		visit_set(e, "boolean")
	end

	visit_exists(e: EXISTS)
	do
		type := "boolean"
		visit_set(e, "boolean")
	end

	visit_counting(e: COUNTING)
	do
		type := "integer"
		visit_set(e, "boolean")
	end

feature -- set

	visit_set_enumeration(se: SET_ENUMERATION)
	local
		a: ANALYSIS
		pivot: STRING_8
	do
		type := "set"

		if se.count = 0 then
			voided := true
		elseif not se.closed then
			voided := true
		else
			create a.make
			visit_node(se.children.at (1), a)
			pivot := a.type

			across se as exp loop
				create a.make
				visit_node(exp.item, a)

				if a.type /~ pivot then
					type_correct := false
				end
			end
		end

	end



invariant
	type~"integer" or type~"boolean" or type~"set" or type~""

end
