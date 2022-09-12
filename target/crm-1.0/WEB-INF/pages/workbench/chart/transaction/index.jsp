<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!-- 引入刚刚下载的 ECharts 文件 -->
    <script src="jquery/echarts/echarts.min.js" charset="UTF-8"></script>
    <title>交易阶段统计图</title>
    <script type="text/javascript">
        $(function () {

            //页面加载完毕之后，展示交易阶段统计图（漏斗图）
            showTranStageStatsChart();

        });

        //展示交易阶段统计图（漏斗图）
        function showTranStageStatsChart(){
            //向后端发起请求
            $.ajax({
                url: "workbench/chart/transaction/showTranStageStatsChart.do",
                dataType: "json",
                success: function (response) {
                    //调用画图插件
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易统计图表',
                            subtext: '交易表中各个阶段的数据量'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b} : {c}'
                        },
                        toolbox: {
                            feature: {
                                dataView: { readOnly: false },
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        legend: {
                            data: response.nameList
                        },
                        series: [
                            {
                                name: '交易阶段',
                                type: 'funnel',
                                left: '10%',
                                width: '80%',
                                maxSize: '80%',
                                label: {
                                    formatter: '{b}',
                                },
                                itemStyle: {
                                    opacity: 0.8,
                                },
                                emphasis: {
                                    label: {
                                        position: 'inside',
                                        formatter: '{b}: {c}%'
                                    }
                                },
                                data: response.dataList,
                                // Ensure outer shape will not be over inner shape when hover.
                                z: 100
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            });
        }


    </script>
</head>
<body>
    <!-- 为 ECharts 准备一个定义了宽高的 DOM -->
    <div id="main" style="width: 1500px;height:800px;"></div>
</body>
</html>