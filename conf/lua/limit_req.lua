local check_script = [[
    local cur = tonumber(redis.call('get', KEYS[1])) or 0
    local limit = tonumber(ARGV[1]) or 0
    if cur < limit then
        redis.call('incr', KEYS[1])
        redis.call('expire', KEYS[1], ARGV[2])
        return 0
    else
        return 1
    end
]]
local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000) -- 1 sec

local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return ngx.exit(503)
end

--- use scripts in eval cmd
local res, err = red:eval(check_script, 1, "limit_req_" .. ngx.time(), 1, 2)
if not res then
    ngx.log(ngx.ERR, "failed to exec redis script: ", err)
    return ngx.exit(503)
end
if res == 1 then
    ngx.log(ngx.ERR, "limit req trigger, try again after 1s")
    return ngx.exit(500)
end

-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end