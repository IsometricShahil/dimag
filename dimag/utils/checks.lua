local checks = {}

function checks.type(v, target, fnName, slot)
	if type(v) ~= target then
		local msg = ("bad argument #%d to '%s' (%s expected, got %s)"):format(
		             slot, fnName, target, type(v) )
		error(msg, 2)
	end
end

function checks.equal(a, b, nameA, nameB)
	if a ~= b then
		local msg = ("%s must be equal to %s (expected %d, got %d)"):format(
		             nameA, nameB, a, b)
		error(msg, 2)
	end
end

return checks