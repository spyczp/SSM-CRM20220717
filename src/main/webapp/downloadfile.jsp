<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <title>测试下载文件</title>
    <script type="text/javascript">

        $(function () {
            $("#downloadBtn").click(function () {
                window.location.href = "workbench/activity/fileDownload.do";
            });
        })

    </script>
</head>
<body>
<h1>测试下载文件</h1>
<input type="button" value="下载" id="downloadBtn">
</body>
</html>
