path = Pathname.new("foo/bar/baz")

arr = [1, 2, 3]
arr.tap { |v| v*3 }
