key  = File.expand_path("./puma_key.pem")
cert = File.expand_path("./puma_cert.pem")
ca   = File.expand_path("~/Library/Application Support/mkcert/rootCA.pem")

bind "tcp://127.0.0.1:9291"

ssl_bind "127.0.0.1", 9292, cert: cert,
                            key:  key,
                            ca:   ca,
                            verify_mode: "peer"

log_requests true

app do |env|
  [200, {}, ["embedded app"]]
end

lowlevel_error_handler do |err|
  [200, {}, ["error page"]]
end
