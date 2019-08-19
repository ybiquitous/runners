# Lint/MultipleCompare is enabled by MeowCop
if 10 < x < 20
  puts 'foo'
end

# It's disabled by MeowCop.
a{|x| x}
