local html = [[
<html>
    <head>
        <title>文件上传</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    </head>
    <body>
        <form action="/api/upload/file" method="post" enctype="multipart/form-data">
            <input name="upload_file" type="file" placeholder="上传文件"><br>
            <input type="submit" value="提交">
        </form>
    </body>
</html>
]]
ngx.say(html)