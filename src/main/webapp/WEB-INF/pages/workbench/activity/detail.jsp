<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

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
		
		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/
		$("#activityRemarkListD").on("mouseover", ".remarkDiv", function () {
			$(this).children("div").children("div").show();
		});
		
		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#activityRemarkListD").on("mouseout", ".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		});
		
		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#activityRemarkListD").on("mouseover", ".myHref", function () {
			$(this).children("span").css("color","red");
		});
		
		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#activityRemarkListD").on("mouseout", ".myHref", function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		//给保存市场活动备注信息按钮添加单击事件：保存市场活动备注信息
		$("#saveActivityRemarkBtn").click(function () {
			var noteContent = $.trim($("#remark").val());
			if(noteContent == ""){
				alert("备注信息不能为空");
				return;
			}
			//向后台发起请求
			$.ajax({
				url: "workbench/activity/createActivityRemark.do",
				data: {
					"noteContent": noteContent,
					"activityId": "${activity.id}"
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//保存成功.添加成功之后,清空输入框,刷新备注列表
						$("#remark").val("");
						showActivityRemarkList();
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给所有的删除图标添加单击事件
		$("#activityRemarkListD").on("click", "a[name='deleteA']", function () {
			//收集参数
			var id = $(this).attr("remarkId");
			//发起请求
			$.ajax({
				url: "workbench/activity/deleteActivityRemarkById.do",
				data:{
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//删除成功，刷新备注信息列表
						showActivityRemarkList();
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给所有的修改图标添加单击事件
		$("#activityRemarkListD").on("click", "a[name='updateA']", function () {
			//收集参数：id，noteContent
			var id = $(this).attr("remarkId");
			//$("#div_"+id+" h5") ===> $("#div_f02a403b9cae4ffa822117b04ca0f3cf h5")
			var noteContent = $("#div_"+id+" h5").text();
			//把id和noteContent写到修改市场活动备注的模态窗口中
            $("#edit-id").val(id);
            $("#edit-noteContent").val(noteContent);
            //打开模态窗口
			$("#editRemarkModal").modal("show");
		});

		//给更新按钮添加单击事件
		$("#updateRemarkBtn").click(function () {
			//收集参数
			var id = $("#edit-id").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			//表单验证
			if(noteContent == ""){
				alert("备注信息不能为空");
				return;
			}
			//向后端发起请求
			$.ajax({
				url: "workbench/activity/saveEditActivityRemark.do",
				data: {
					"id": id,
					"noteContent": noteContent
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//成功，刷新市场活动备注列表，关闭模态窗口
						showActivityRemarkList();
						$("#editRemarkModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});
	});

	//刷新市场活动备注列表
	function showActivityRemarkList(){
		//向后台获取市场活动备注信息列表
		$.ajax({
			url: "workbench/activity/showActivityRemarkListByActivityId.do",
			type: "post",
			data: {
				"activityId": "${activity.id}"
			},
			dataType: "json",
			success: function (response) {
				//拼接html标签，展示市场活动备注列表
				var html = "";
				$.each(response, function(i, o){
					html += '<div id="div_'+o.id+'" name="activityRemarkD" class="remarkDiv" style="height: 60px;">';
					html += '<img title="'+o.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+o.noteContent+'</h5>';
					html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>'+o.activityId+'</b> <small style="color: gray;"> ';
					html += (o.editFlag == "1" ? o.editTime : o.createTime) + '由' + (o.editFlag == "1" ? o.editBy : o.createBy) + (o.editFlag == "1" ? "修改" : "创建") + '</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" name="updateA" remarkId="'+o.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" name="deleteA" remarkId="'+o.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				});
				//清空原来的市场活动备注列表标签
				$("#activityRemarkListD div[name='activityRemarkD']").remove();
				//追加标签
				$("#remarkDiv").before(html);
			}
		});
	}
	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <input type="hidden" id="edit-id">
                        <div class="form-group">
                            <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="activityRemarkListD" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${activityRemarks}" var="remark">
			<div id="div_${remark.id}" name="activityRemarkD" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${remark.activityId}</b> <small style="color: gray;"> ${remark.editFlag == "1" ? remark.editTime : remark.createTime} 由${remark.editFlag == "1" ? remark.editBy : remark.createBy}${remark.editFlag == "1" ? "修改" : "创建"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="updateA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button id="saveActivityRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>