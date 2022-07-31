<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta charset="UTF-8">
    <title>文件上传</title>
</head>
<body>
<h1>文件上传</h1>
<form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
    <input type="text" name="userName"><br>
    <input type="file" name="myFile"><br>
    <input type="submit" value="提交">
</form>
</body>
</html>
