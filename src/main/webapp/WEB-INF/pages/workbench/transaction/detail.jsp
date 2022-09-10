<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//展示阶段图标
	showTranStageIcon("${tran.stage}");

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		//阶段提示框
		$("#stageIconDiv").on("mouseenter", "span[name='stageIcon']", function () {
			$(this).popover({
				trigger:'manual',
				placement : 'bottom',
				html: 'true',
				animation: false
			});
			var _this = this;
			$(this).popover("show");
			$(this).siblings(".popover").on("mouseleave", function () {
				$(_this).popover('hide');
			});
		});
		//阶段提示框
		$("#stageIconDiv").on("mouseleave", "span[name='stageIcon']", function () {
			$(this).popover({
				trigger:'manual',
				placement : 'bottom',
				html: 'true',
				animation: false
			});
			var _this = this;
			setTimeout(function () {
				if (!$(".popover:hover").length) {
					$(_this).popover("hide")
				}
			}, 100);
		});

		//阶段提示框
		/*$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });*/


		//给 阶段图标 添加单击事件
		$("#stageIconDiv").on("click", "span[name='stageIcon']", function () {
			//收集参数：当前阶段名称、当前阶段id、交易id
			var newStageValue = $(this).attr("data-content");
			var newStageId = $(this).attr("stageId");
			var tranId = $("#hidden-tranId").val();

			//向后端发起请求，更新本条交易的阶段数据、新增一条交易历史
			$.ajax({
				url: "workbench/transaction/saveChangeATranStage.do",
				data:{
					"stageId": newStageId,
					"tranId": tranId
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//修改阶段成功
						//刷新阶段图标
						showTranStageIcon(newStageValue);
						//刷新阶段历史列表
						showTranHistoryList();
					}else{
						alert(response.message);
					}
				}

			});
		});

		//测试生成图标
		/*$("#testBtn").click(function () {
			showTranHistoryList();
		});*/
	});

	//展示阶段历史列表
	function showTranHistoryList(){
		//收集参数
		var tranId = $("#hidden-tranId").val();
		//向后端发起请求
		$.ajax({
			url: "workbench/transaction/showTranHistoryList.do",
			data: {
				"tranId": tranId
			},
			type: "post",
			dataType: "json",
			success: function (response) {
				//字符串拼接，组装html标签，展示交易阶段历史列表
				var html = "";
				$.each(response, function (i, o) {
					html += '<tr>';
					html += '<td>'+o.stage+'</td>';
					html += '<td>￥'+o.money+'</td>';
					html += '<td>'+o.expectedDate+'</td>';
					html += '<td>'+o.createTime+'</td>';
					html += '<td>'+o.createBy+'</td>';
					html += '</tr>';
				});
				//组装html标签，展示交易阶段历史列表
				$("#tranHistoryListTB").html(html);
			}
		});
	}

    //展示阶段图标
    //把 当前阶段名称 作为参数传递进去：stage
    function showTranStageIcon(stage) {
        //向后端发起请求，获得stageList和possibilityList
        $.ajax({
            url: "workbench/transaction/showStageIcon.do",
            dataType: "json",
            success: function (response) {
                //判断，组装阶段图标
				var nowStageNo = "";
				$.each(response.stageList, function (i, o) {
					//遍历stageList，找到当前stage，获得当前stage的orderNo。
					if(o.value == stage){
						//获得当前阶段的orderNo。
						nowStageNo = o.orderNo;
					}
				});
				/*
				* 判断方式：循环遍历stageList，判断每个阶段
				* 1.首先判断当前阶段的可能性是否为0
				* 	若为0，
				* 		当前阶段画红×。
				* 		当前阶段之前的阶段，画黑圈，或者黑×。
				* 			阶段可能性为0，画黑×，
				* 			阶段可能性不为0，画黑圈。
				* 		当前阶段之后的阶段，画黑×
				* 	若不为0，
				* 		当前阶段画绿标，
				* 		当前阶段之前的阶段，画绿勾。
				* 		当前阶段之后的阶段，画黑圈或者黑×。
				* 			阶段可能性为0，画黑×
				* 			阶段可能性不为0，画黑圈
				* */
				var html = "阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				//1.首先判断当前阶段的可能性是否为0
				//若为0，
				if(response.possibilityList[stage] == 0){
					$.each(response.stageList, function(i, o){
						//当前阶段画红×。
						if(o.orderNo == nowStageNo){
							html += '<span name="stageIcon" stageId="'+o.id+'" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="'+o.value+'" style="color: red;"></span>';
							html += '-----------';

							//当前阶段之前的阶段，画黑圈，或者黑×。
							//	阶段可能性为0，画黑×，
						}else if(o.orderNo < nowStageNo && response.possibilityList[o.value] == 0){
							html += '<span name="stageIcon" stageId="'+o.id+'" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="'+o.value+'"></span>';
							html += '-----------';

							//阶段可能性不为0，画黑圈。
						}else if(o.orderNo < nowStageNo && response.possibilityList[o.value] != 0){
							html += '<span name="stageIcon" stageId="'+o.id+'" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="'+o.value+'"></span>';
							html += '-----------';

							//当前阶段之后的阶段，画黑×
						}else if(o.orderNo > nowStageNo){
							html += '<span name="stageIcon" stageId="'+o.id+'" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="'+o.value+'"></span>';
							html += '-----------';
						}
					});
					//若不为0，
				}else{
					$.each(response.stageList, function (i, o) {
						//当前阶段画绿标，
						if(o.orderNo == nowStageNo){
							html += '<span name="stageIcon" stageId="'+o.id+'" class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="'+o.value+'" style="color: #90F790;"></span>';
							html += '-----------';

							//当前阶段之前的阶段，画绿勾。
						}else if(o.orderNo < nowStageNo){
							html += '<span name="stageIcon" stageId="'+o.id+'" class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="'+o.value+'" style="color: #90F790;"></span>';
							html += '-----------';

							//当前阶段之后的阶段，画黑圈或者黑×。
							//阶段可能性为0，画黑×
						}else if(o.orderNo > nowStageNo && response.possibilityList[o.value] == 0){
							html += '<span name="stageIcon" stageId="'+o.id+'" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="'+o.value+'"></span>';
							html += '-----------';

							//阶段可能性不为0，画黑圈
						}else if(o.orderNo > nowStageNo && response.possibilityList[o.value] != 0){
							html += '<span name="stageIcon" stageId="'+o.id+'" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="'+o.value+'"></span>';
							html += '-----------';
						}
					});
				}
				//展示阶段图标
				html += '<span class="closingDate">${tran.expectedDate}</span>';
				$("#stageIconDiv").html(html);
            }
        });
    }
	
	
	
</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>

	<%--<input type="button" id="testBtn">--%>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<input type="hidden" id="hidden-tranId" value="${tran.id}">
		<div class="page-header">
			<h3>${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div id="stageIconDiv" style="position: relative; left: 40px; top: -50px;">
		<%--阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-----------
		<span class="closingDate">${tran.expectedDate}</span>--%>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>￥${tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${possibility}%</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${tranRemarkList}" var="tr">
			<div class="remarkDiv" style="height: 60px;">
				<img title="${tr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${tr.noteContent}</h5>
					<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.name}</b> <small style="color: gray;"> ${tr.editFlag == '0' ? tr.createTime : tr.editTime} 由${tr.editFlag == '0' ? tr.createBy : tr.editBy}${tr.editFlag == '0' ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="tranHistoryListTB">
						<c:forEach items="${tranHistoryList}" var="th">
							<tr>
								<td>${th.stage}</td>
								<td>￥${th.money}</td>
								<td>${th.expectedDate}</td>
								<td>${th.createTime}</td>
								<td>${th.createBy}</td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>