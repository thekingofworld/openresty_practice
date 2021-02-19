local function isInvalid(arg)
    local from, to, err = ngx.re.find(arg, ".*(shell|bash|root|select .* from).*", "jo")
    if not from then
        return false
    end
    return true
end

local arg = ngx.req.get_uri_args()
for k,v in pairs(arg) do
    if isInvalid(k) or isInvalid(v) then
        ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end
end

ngx.req.read_body() -- 解析 body 参数之前一定要先读取 body
local arg = ngx.req.get_post_args()
for k,v in pairs(arg) do
    if isInvalid(k) or isInvalid(v) then
        ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end
end

ngx.log(ngx.INFO, "waf check success")