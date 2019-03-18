note
	description: "Summary description for {PRETTY_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRETTY_PRINTER
inherit
	VISITOR

create
	make, make_sub

feature
	make
	do
		printed := ""
	end

feature
	printed: STRING

feature{NONE} -- helper
	visit_void
	do
		if voided then
			printed.append ("nil")
		else
			printed.append ("?")
			voided:=True
		end
	end

	visit_node(node: detachable EXPRESSION; p: like current)
	do
		if attached node as n then
			n.accept (p)
			printed.append (p.printed)
			if p.voided then
				voided:=True
			end
		else
			visit_void
		end
	end

	visit_binary_operation(e: BINARY_OPERATION; s: STRING)
	local
		p1, p2: PRETTY_PRINTER
	do
		create p1.make_sub (voided)

		printed.append ("(")
		visit_node(e.left, p1)

		printed.append (s)

		create p2.make_sub (voided)

		visit_node(e.right, p2)
		printed.append (")")
	end

	visit_unary_operation(e: UNARY_OPERATION; s: STRING)
	local
		p: PRETTY_PRINTER
	do
		create p.make_sub (voided)

		printed.append ("(")

		printed.append (s)

		visit_node(e.right, p)
		printed.append (")")

	end

feature -- constant

	visit_integer_constant(e: INTEGER_CONSTANT)
	do
		printed.append_integer (e.value)
	end

	visit_boolean_constant(e: BOOLEAN_CONSTANT)
	do
		printed.append_boolean (e.value)
	end

feature -- binary ops

	visit_plus(e: PLUS)
	do
		visit_binary_operation(e, " + ")
	end

	visit_minus(e: MINUS)
	do
		visit_binary_operation(e, " - ")
	end

	visit_times(e: TIMES)
	do
		visit_binary_operation(e, " * ")
	end

	visit_quotient(e: QUOTIENT)
	do
		visit_binary_operation(e, " / ")
	end

	visit_mod(e: MOD)
	do
		visit_binary_operation(e, " mod ")
	end

	visit_logic_and(e: LOGIC_AND)
	do
		visit_binary_operation(e, " && ")
	end

	visit_logic_or(e: LOGIC_OR)
	do
		visit_binary_operation(e, " || ")
	end

	visit_logic_xor(e: LOGIC_XOR)
	do
		visit_binary_operation(e, " xor ")
	end

	visit_logic_implies(e: LOGIC_IMPLIES)
	do
		visit_binary_operation(e, " => ")
	end

	visit_logic_equal(e: LOGIC_EQUAL)
	do
		visit_binary_operation(e, " = ")
	end

	visit_gt(e: GT)
	do
		visit_binary_operation(e, " > ")
	end

	visit_lt(e: LT)
	do
		visit_binary_operation(e, " < ")
	end

	visit_union(e: UNION)
	do
		visit_binary_operation(e, " \/ ")
	end

	visit_intersect(e: INTERSECT)
	do
		visit_binary_operation(e, " /\ ")
	end

	visit_difference(e: DIFFERENCE)
	do
		visit_binary_operation(e, " \ ")
	end

feature -- unary ops

	visit_negative(e: NEGATIVE)
	do
		visit_unary_operation(e, "- ")
	end

	visit_negation(e: NEGATION)
	do
		visit_unary_operation(e, "! ")
	end

	visit_sigma(e: SIGMA)
	do
		visit_unary_operation(e, "+ ")
	end

	visit_product(e: PRODUCT)
	do
		visit_unary_operation(e, "* ")
	end

	visit_forall(e: FORALL)
	do
		visit_unary_operation(e, "&& ")
	end

	visit_exists(e: EXISTS)
	do
		visit_unary_operation(e, "|| ")
	end

	visit_counting(e: COUNTING)
	do
		visit_unary_operation(e, "# ")
	end


feature -- set enum

	visit_set_enumeration(se: SET_ENUMERATION)
	local
		count:INTEGER
		p: PRETTY_PRINTER
	do
		if se.children.is_empty then
			printed.append ("{")
			visit_void
			printed.append ("}")
		else
			printed.append ("{")
			count:=1
			across se as exp loop
				create p.make_sub(voided)
				visit_node(exp.item, p)

				if count < se.count then
					printed.append (", ")
				end
				count := count+1
			end
			if se.can_add then
				if not voided then
					printed.append (", ?")
					voided := true
				end
			end
			printed.append ("}")
		end

	end



end
