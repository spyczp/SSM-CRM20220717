<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <!--  It is a good idea to bundle all CSS in one file. The same with JS -->

    <!--  JQUERY -->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <!--  BOOTSTRAP -->
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <!--  PAGINATION plugin -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#demo_pagination").bs_pagination({
                totalPages: 100,
                currentPage: 1,
                rowsPerPage: 10,
                totalRows: 1000,
                visiblePageLinks: 10,
                onChangePage: function(event, pageObj) { // returns page_num and rows_per_page after a link has clicked
                    alert(pageObj.currentPage);
                    alert(pageObj.rowsPerPage);
                }
            });
        });
    </script>
    <title>bootstrap分页组件测试</title>
</head>
<body>
    <h1>bootstrap分页组件测试</h1>
    <div id="demo_pagination"></div>
</body>
</html>
