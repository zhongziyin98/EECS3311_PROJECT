note
	description: "Summary description for {VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VISITOR

feature
	-- have we already encountered a void node in the expression tree?
	voided: BOOLEAN

feature
	make
	deferred end

	make_sub(b: BOOLEAN)
	do
		make
		voided:=b
	end

feature -- constant
	visit_integer_constant(e:INTEGER_CONSTANT)
	deferred end

	visit_boolean_constant(e: BOOLEAN_CONSTANT)
	deferred end


feature -- binary ops
	visit_plus(e:PLUS)
	deferred end

	visit_minus(e: MINUS)
	deferred end

	visit_times(e: TIMES)
	deferred end

	visit_quotient(e: QUOTIENT)
	deferred end

	visit_mod(e: MOD)
	deferred end

	visit_logic_and(e: LOGIC_AND)
	deferred end

	visit_logic_or(e: LOGIC_OR)
	deferred end

	visit_logic_xor(e: LOGIC_XOR)
	deferred end

	visit_logic_implies(e: LOGIC_IMPLIES)
	deferred end

	visit_logic_equal(e: LOGIC_EQUAL)
	deferred end

	visit_gt(e: GT)
	deferred end

	visit_lt(e: LT)
	deferred end

	visit_union(e: UNION)
	deferred end

	visit_intersect(e: INTERSECT)
	deferred end

	visit_difference(e: DIFFERENCE)
	deferred end

feature -- unary ops
	visit_negative(e: NEGATIVE)
	deferred end

	visit_negation(e: NEGATION)
	deferred end

	visit_sigma(e: SIGMA)
	deferred end

	visit_product(e: PRODUCT)
	deferred end

	visit_forall(e: FORALL)
	deferred end

	visit_exists(e: EXISTS)
	deferred end

	visit_counting(e: COUNTING)
	deferred end

feature -- set
	visit_set_enumeration(se: SET_ENUMERATION)
	deferred end

end
