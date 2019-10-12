environment "production"
workers 1
app do |env|
  [200, {}, ["embedded app"]]
end
