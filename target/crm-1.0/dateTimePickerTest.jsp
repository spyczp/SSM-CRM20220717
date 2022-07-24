<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <link rel="stylesheet" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <title>演示bs_datetimepicker插件</title>
<script type="text/javascript">
    $(function () {
        $("#myDate").datetimepicker({
            language: "en",
            format: "yyyy-mm-dd",
            autoclose: true,
            minView: "month",
            initialDate: new Date(),
            todayBtn: true,
            clearBtn: true
        });

        $("#datetimepicker").datetimepicker({
            language: "zh-CN",
            format: "yyyy-mm-dd",
            autoclose: true,
            minView: "month",
            initialDate: new Date()
        });
    })
</script>
</head>
<body>
<h1>日期选择器</h1>
<input type="text" id="myDate" readonly>

<div class="input-append date" id="datetimepicker" data-date="12-02-2012" data-date-format="dd-mm-yyyy">
    <input class="span2" size="16" type="text" value="12-02-2012">
    <span class="add-on"><i class="icon-remove"></i></span>
    <span class="add-on"><i class="icon-th"></i></span>
</div>
</body>
</html>