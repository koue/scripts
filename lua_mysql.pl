require "luasql.mysql"
env = assert (luasql.mysql())
con = assert (env:connect("database","username","password","server"))
cur = assert (con:execute ("SELECT id, name from table" ))

-- print all rows, the rows will be indexed by field names
row = cur:fetch ({}, "a")

while row do
  table.foreach (row, print)

  -- reusing the table of results
  row = cur:fetch ({}, "a")
end

-- close everything
cur:close()
con:close()
env:close()
