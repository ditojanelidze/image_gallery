conf = Rails.application.config_for(:redis)['redis_auth_conf'].symbolize_keys

$redis = Redis.new({url: "redis://#{conf[:host]}:#{conf[:port]}/#{conf[:db]}"})
