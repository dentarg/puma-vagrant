workers 1
app do |env|
  foo = "foo"
  [200, {}, ["embedded #{foo*99} app\n"]]
end
