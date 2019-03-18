note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			root := void
			message := msg_init
			restartable:=false

			create sets.make
		end


feature {ETF_COMMAND} -- attr
	root: detachable EXPRESSION
	message: STRING
	sets: LINKED_LIST[SET_ENUMERATION]

feature -- queries
	restartable: BOOLEAN

	can_add: BOOLEAN
	do
		if attached root as r then
			Result := r.can_add
		else
			Result := true
		end
	end

	type_correct: BOOLEAN
	local
		a: ANALYSIS
	do
		create a.make
		if attached {EXPRESSION} root as r then
			r.accept (a)
			Result := a.type_correct and not a.voided
		else
			Result := false
		end
	end


feature {ETF_COMMAND} -- user command

	add_expression(e: EXPRESSION) -- add a REFERENCE of e to the expression tree
	require
		can_add -- given tree is not full
	do
		if attached root as r then
			check attached {COMPOSITION} r as rr then -- then root either is a composition or is void
				rr.add_expression(e)
			end
		else
			root := e
		end
		message := msg_ok


		cooldown
	end

	analyze
	local
		a: ANALYSIS
		p: PRETTY_PRINTER
	do
		create a.make
		if attached {EXPRESSION} root as r then
			r.accept (a)
			if a.voided then -- incomplete
				message := msg_incomplete_exp
			else
				create p.make
				r.accept (p)
				message := ""
				message.append(p.printed)
				message.append(" ")
				if not a.type_correct then -- type
					message.append("is not type-correct.")
				else
					message.append("is type-correct.")
				end
			end
		else
			message := msg_incomplete_exp
		end


		cooldown
	end


	end_of_set_enumeration
	require
		not sets.is_empty
	local
		se: SET_ENUMERATION
	do
		se := sets.at (sets.count)
		se.close

		sets.go_i_th (sets.count)
		sets.remove
		message := msg_ok

		cooldown
	end

	restart
	require
		cooldown: restartable
	do
		make
		message := msg_ok
	end

	simplify
	require
		type_correct: type_correct
	local
		s: SIMPLIFY
		e: EXPRESSION
		p: PRETTY_PRINTER
	do
		create s.make
		create p.make
		check attached {EXPRESSION} root as r then
			r.accept (s)
			if s.division_by_zero then
				message := msg_d0
			else
				e := s.ans_as_expression
				e.accept (p)
				message := p.printed
			end
		end


		cooldown
	end

feature {ETF_COMMAND} -- helper cmd

	set_message(s: STRING)
	do
		message := s
	end

	cooldown
	do
		restartable := true
	end

	push_set(se: SET_ENUMERATION)
	do
		sets.force (se)
	end


feature -- model operations -- generated
--	default_update
--		-- Perform update to the model state.
--	do
--		-- nop
--	end

	reset
		-- Reset model state.
	do
		make
	end

feature -- printing queries

	print_expression: STRING
	local
		p: PRETTY_PRINTER
	do
		create p.make
		if attached {EXPRESSION} root as r then
			r.accept (p)
			Result := p.printed
		else
			Result := "?"
		end
	end

	out : STRING
	do
		-- expression
		create Result.make_from_string ("  ")
		Result.append("Expression currently specified: ")
		Result.append (print_expression)
		Result.append ("%N")

		-- model state
		Result.append ("  ")
		Result.append ("Report: ")
		Result.append (message)
	end


feature {ETF_COMMAND} -- message

	msg_init: STRING
	once
		Result := "Expression is initialized."
	end

	msg_ok: STRING
	once
		Result := "OK."
	end

	msg_incomplete_exp: STRING
	once
		Result := "Error (Expression is not yet fully specified)."
	end

	msg_complete_exp: STRING
	once
		Result := "Error (Expression is already fully specified)."
	end

	msg_type: STRING
	once
		Result := "Error (Expression is not type-correct)."
	end

	msg_reset: STRING
	once
		Result := "Error (Initial expression cannot be reset)."
	end

	msg_d0: STRING
	once
		Result := "Error (Divisor is zero)."
	end

	msg_missing_set: STRING
	once
		Result := "Error (Set enumeration is not being specified)."
	end

	msg_empty_set: STRING
	once
		Result := "Error: (Set enumeration must be non-empty)."
	end

end




