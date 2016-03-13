local ftcsv = require('ftcsv')

describe("csv features", function()
	it("should handle loading from string", function()
		local expected = {}
		expected[1] = {}
		expected[1].a = "apple"
		expected[1].b = "banana"
		expected[1].c = "carrot"
		local actual = ftcsv.parse("a,b,c\napple,banana,carrot", ",", {loadFromString=true})
		assert.are.same(expected, actual)
	end)

	it("should handle crlf loading from string", function()
		local expected = {}
		expected[1] = {}
		expected[1].a = "apple"
		expected[1].b = "banana"
		expected[1].c = "carrot"
		local actual = ftcsv.parse("a,b,c\r\napple,banana,carrot", ",", {loadFromString=true})
		assert.are.same(expected, actual)
	end)

	it("should handle renaming a field", function()
		local expected = {}
		expected[1] = {}
		expected[1].d = "apple"
		expected[1].b = "banana"
		expected[1].c = "carrot"
		local actual = ftcsv.parse("a,b,c\r\napple,banana,carrot", ",", {loadFromString=true, rename={["a"] = "d"}})
		assert.are.same(expected, actual)
	end)

	it("should handle renaming multiple fields", function()
		local expected = {}
		expected[1] = {}
		expected[1].d = "apple"
		expected[1].e = "banana"
		expected[1].f = "carrot"
		local options = {loadFromString=true, rename={["a"] = "d", ["b"] = "e", ["c"] = "f"}}
		local actual = ftcsv.parse("a,b,c\r\napple,banana,carrot", ",", options)
		assert.are.same(expected, actual)
	end)

	it("should handle renaming multiple fields to the same out value", function()
		local expected = {}
		expected[1] = {}
		expected[1].d = "apple"
		expected[1].e = "carrot"
		local options = {loadFromString=true, rename={["a"] = "d", ["b"] = "e", ["c"] = "e"}}
		local actual = ftcsv.parse("a,b,c\r\napple,banana,carrot", ",", options)
		assert.are.same(expected, actual)
	end)

	it("should handle renaming multiple fields to the same out value with newline at end", function()
		local expected = {}
		expected[1] = {}
		expected[1].d = "apple"
		expected[1].e = "carrot"
		local options = {loadFromString=true, rename={["a"] = "d", ["b"] = "e", ["c"] = "e"}}
		local actual = ftcsv.parse("a,b,c\r\napple,banana,carrot\r\n", ",", options)
		assert.are.same(expected, actual)
	end)

	it("should handle only keeping a few fields", function()
		local expected = {}
		expected[1] = {}
		expected[1].a = "apple"
		expected[1].b = "banana"
		local options = {loadFromString=true, fieldsToKeep={"a","b"}}
		local actual = ftcsv.parse("a,b,c\r\napple,banana,carrot\r\n", ",", options)
		assert.are.same(expected, actual)
	end)

	it("should handle only keeping a few fields with a rename to an existing field", function()
		local expected = {}
		expected[1] = {}
		expected[1].a = "apple"
		expected[1].b = "carrot"
		local options = {loadFromString=true, fieldsToKeep={"a","b"}, rename={["c"] = "b"}}
		local actual = ftcsv.parse("a,b,c\r\napple,banana,carrot\r\n", ",", options)
		assert.are.same(expected, actual)
	end)

	it("should handle only keeping a few fields with a rename to a new field", function()
		local expected = {}
		expected[1] = {}
		expected[1].a = "apple"
		expected[1].f = "carrot"
		local options = {loadFromString=true, fieldsToKeep={"a","f"}, rename={["c"] = "f"}}
		local actual = ftcsv.parse("a,b,c\r\napple,banana,carrot\r\n", ",", options)
		assert.are.same(expected, actual)
	end)

	it("should handle files without headers", function()
		local expected = {}
		expected[1] = {}
		expected[1][1] = "apple"
		expected[1][2] = "banana"
		expected[1][3] = "carrot"
		expected[2] = {}
		expected[2][1] = "diamond"
		expected[2][2] = "emerald"
		expected[2][3] = "pearl"
		local options = {loadFromString=true, header=false}
		local actual = ftcsv.parse("apple>banana>carrot\ndiamond>emerald>pearl", ">", options)
	end)

end)