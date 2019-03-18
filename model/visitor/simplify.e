note
	description: "Summary description for {ANALYSIS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLIFY

inherit
	VISITOR

create
	make

feature
	make
	do
		ans_integer := 0
		ans_boolean := False
		create ans_set.make_empty
	end

feature
	ans_integer : INTEGER
	ans_boolean : BOOLEAN

	ans_set : ARRAY[EXPRESSION]

	is_integer: BOOLEAN
	is_boolean: BOOLEAN
	is_set: BOOLEAN

feature
	ans_as_expression: EXPRESSION
	do
		if is_integer then
			create {INTEGER_CONSTANT} Result.make (ans_integer)
		elseif is_boolean then
			create {BOOLEAN_CONSTANT} Result.make (ans_boolean)
		--elseif is_set then
		else
			create {SET_ENUMERATION} Result.make
			across ans_set as e loop
				check attached {SET_ENUMERATION} Result as r then
					r.add_expression(e.item)
				end
			end
			check attached {SET_ENUMERATION} Result as r then
				r.close
			end

		end
	end

	division_by_zero: BOOLEAN

feature -- check

	type_correct(e: EXPRESSION): BOOLEAN
	local
		a: ANALYSIS
	do
		create a.make
		e.accept (a)
		Result := a.type_correct and not a.voided
	end

feature {NONE}
	visit_binary_operation(e: BINARY_OPERATION; op: STRING)
	require
		type_correct(e)
	local
		l, r: SIMPLIFY
		sl, sr: SET[EXPRESSION]
	do
		create l.make
		create r.make

		check (attached e.left as left) and (attached e.right as right) then
			left.accept (l)
			right.accept (r)
		end

		division_by_zero := division_by_zero or l.division_by_zero or r.division_by_zero

		if not division_by_zero then

			if op~"+" then
				ans_integer := l.ans_integer + r.ans_integer
			elseif op~"-" then
				ans_integer := l.ans_integer - r.ans_integer
			elseif op~"*" then
				ans_integer := l.ans_integer * r.ans_integer
			elseif op~"//" then
				if r.ans_integer = 0 then
					division_by_zero := true
				else
					ans_integer := l.ans_integer // r.ans_integer
				end
			elseif op~"\\" then
				if r.ans_integer = 0 then
					division_by_zero := true
				else
					ans_integer := l.ans_integer \\ r.ans_integer
				end
			elseif op~"/\" then
				ans_boolean := l.ans_boolean and r.ans_boolean
			elseif op~"\/" then
				ans_boolean := l.ans_boolean or r.ans_boolean
			elseif op~"xor" then
				ans_boolean := l.ans_boolean xor r.ans_boolean
			elseif op~"=>" then
				ans_boolean := l.ans_boolean implies r.ans_boolean
			elseif op~"=" then
				if l.is_set and r.is_set then
					ans_boolean := (l.ans_boolean = r.ans_boolean) and (l.ans_integer = r.ans_integer)
				else
					create sl.make_from_array (l.ans_set)
					create sr.make_from_array (r.ans_set)
					ans_boolean := sl.is_equal (sr)
				end
			elseif op~">" then
				ans_boolean := l.ans_integer > r.ans_integer
			elseif op~"<" then
				ans_boolean := l.ans_integer < r.ans_integer
			elseif op~"union" then
				create sl.make_from_array (l.ans_set)
				create sr.make_from_array (r.ans_set)
				sl.union (sr)
				ans_set := sl.as_array
			elseif op~"intersect" then
				create sl.make_from_array (l.ans_set)
				create sr.make_from_array (r.ans_set)
				sl.intersect (sr)
				ans_set := sl.as_array

			elseif op~"difference" then
				create sl.make_from_array (l.ans_set)
				create sr.make_from_array (r.ans_set)
				sl.difference (sr)
				ans_set := sl.as_array
			end
		end

	end

	visit_unary_operation(e: UNARY_OPERATION; op: STRING)
	require
		type_correct(e)
	local
		r: SIMPLIFY
		s: SIMPLIFY
	do
		create r.make

		check attached e.right as right then
			right.accept (r)
		end

		division_by_zero := division_by_zero or r.division_by_zero

		if not division_by_zero then

			if op~"-" then
				ans_integer := - r.ans_integer
			elseif op~"!" then
				ans_boolean := not r.ans_boolean
			elseif op~"+" then
				across r.ans_set as exp loop
					create s.make
					exp.item.accept(s)
					ans_integer := ans_integer + s.ans_integer
				end
			elseif op~"*" then
				ans_integer := 1
				across r.ans_set as exp loop
					create s.make
					exp.item.accept(s)
					ans_integer := ans_integer * s.ans_integer
				end
			elseif op~"&&" then
				across r.ans_set as exp loop
					create s.make
					exp.item.accept(s)
					ans_boolean := ans_boolean and s.ans_boolean
				end
			elseif op~"||" then
				across r.ans_set as exp loop
					create s.make
					exp.item.accept(s)
					ans_boolean := ans_boolean or s.ans_boolean
				end
			elseif op~"#" then
				across r.ans_set as exp loop
					create s.make
					exp.item.accept(s)
					if s.ans_boolean then
						ans_integer := ans_integer + 1
					end
				end
			end

		end



	end

feature -- constant
	visit_integer_constant(e: INTEGER_CONSTANT)
	do
		is_integer := true
		ans_integer := e.value
	end

	visit_boolean_constant(e: BOOLEAN_CONSTANT)
	do
		is_integer := true
		ans_boolean := e.value
	end

feature -- binary ops

	visit_plus(e: PLUS)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_binary_operation(e, "+")
	end

	visit_minus(e: MINUS)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_binary_operation(e, "-")
	end

	visit_times(e: TIMES)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_binary_operation(e, "*")
	end

	visit_quotient(e: QUOTIENT)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_binary_operation(e, "//")
	end

	visit_mod(e: MOD)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_binary_operation(e, "\\")
	end

	visit_logic_and(e: LOGIC_AND)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_binary_operation(e, "/\")
	end

	visit_logic_or(e: LOGIC_OR)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_binary_operation(e, "\/")
	end

	visit_logic_xor(e: LOGIC_XOR)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_binary_operation(e, "xor")
	end

	visit_logic_implies(e: LOGIC_IMPLIES)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_binary_operation(e, "=>")
	end

	visit_logic_equal(e: LOGIC_EQUAL)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_binary_operation(e, "=")
	end

	visit_gt(e: GT)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_binary_operation(e, ">")
	end

	visit_lt(e: LT)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_binary_operation(e, "<")
	end

	visit_union(e: UNION)
	require else
		type_correct(e)
	do
		is_set := true
		visit_binary_operation(e, "union")
	end

	visit_intersect(e: INTERSECT)
	require else
		type_correct(e)
	do
		is_set := true
		visit_binary_operation(e, "intersect")
	end

	visit_difference(e: DIFFERENCE)
	require else
		type_correct(e)
	do
		is_set := true
		visit_binary_operation(e, "difference")
	end

feature -- unary ops

	visit_negative(e: NEGATIVE)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_unary_operation(e, "-")
	end

	visit_negation(e: NEGATION)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_unary_operation(e, "!")
	end

	visit_sigma(e: SIGMA)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_unary_operation(e, "+")
	end

	visit_product(e: PRODUCT)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_unary_operation(e, "*")
	end

	visit_forall(e: FORALL)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_unary_operation(e, "&&")
	end

	visit_exists(e: EXISTS)
	require else
		type_correct(e)
	do
		is_boolean := true
		visit_unary_operation(e, "||")
	end

	visit_counting(e: COUNTING)
	require else
		type_correct(e)
	do
		is_integer := true
		visit_unary_operation(e, "#")
	end


feature -- set enum

	visit_set_enumeration(se: SET_ENUMERATION)
	require else
		type_correct(se)
	local
		s: SIMPLIFY
	do
		is_set := true
		across se as e loop
			create s.make
			e.item.accept (s)
--			if s.is_boolean then -- simplify removes same boolean?
--				if not ans_set.has (s.ans_as_expression) then
--					ans_set.force ()
--				end
--			else
				ans_set.force (e.item, ans_set.count+1)
		--	end

		end
	end

end
