local _M = {version = 0.3}
local count = 1

function _M.log()
    count = count + 1
    ngx.log(ngx.ERR, count)
end

return _M