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
		$("#clueRemarkListDiv").on("mouseover", ".remarkDiv", function () {
			$(this).children("div").children("div").show();
		});

		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#clueRemarkListDiv").on("mouseout", ".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		});

		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#clueRemarkListDiv").on("mouseover", ".myHref", function () {
			$(this).children("span").css("color","red");
		});

		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#clueRemarkListDiv").on("mouseout", ".myHref", function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		//给保存按钮添加单击事件
		$("#saveCreateClueRemarkBtn").click(function () {
			//收集数据
			var noteContent = $("#remark").val();
			var clueId = "${clue.id}";

			//向后端发起请求
			$.ajax({
				url: "workbench/clue/createClueRemark.do",
				data: {
					"noteContent": noteContent,
					"clueId": clueId
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//新增线索备注成功，刷新线索备注列表
						showClueRemarkList();
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给修改线索备注图标添加单击事件
		$("#clueRemarkListDiv").on("click", "a[name='updateA']", function () {
			//收集参数
			var id = $(this).attr("remarkId");
			//$("#div_"+id+" h5") ===> $("#div_f02a403b9cae4ffa822117b04ca0f3cf h5")
			var noteContent = $("#div_" + id + " h5").text();
			//填值
			$("#remarkId").val(id);
			$("#edit-noteContent").val(noteContent);
			//打开修改备注的模态窗口
			$("#editRemarkModal").modal("show");
		});

		//给修改线索备注的模态窗口中的更新按钮添加单击事件
		$("#updateRemarkBtn").click(function () {
			//收集参数
			var id = $("#remarkId").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			//验证内容
			if(noteContent == ""){
				alert("线索备注内容不能为空");
				return;
			}
			//向后端发起请求，更新备注信息
			$.ajax({
				url: "workbench/clue/editClueRemark.do",
				data: {
					"id": id,
					"noteContent": noteContent
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//修改成功，刷新线索备注列表,关闭模态窗口
						showClueRemarkList();
						$("#editRemarkModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});


		//给删除线索备注的图标添加单击事件
		$("#clueRemarkListDiv").on("click", "a[name='deleteA']", function () {
			//收集参数
			var id = $(this).attr("remarkId");

			//向后端发起请求
			$.ajax({
				url: "workbench/clue/deleteClueRemark.do",
				data: {
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//删除成功，刷新线索备注列表
						showClueRemarkList();
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给 关联市场活动 的a标签添加单击事件
		$("a[name='boundActivityA']").click(function () {
			//去掉全选复选框的勾
			$("#checkedAll").prop("checked", false);
			//清空市场活动列表
			$("#activityListTB").empty();
			//清空搜索框
			$("#search-activityName").val("");
			//打开关联市场活动的模态窗口
			$("#bundModal").modal("show");
		});

		//给关联市场活动的模态窗口中的 查询按钮 添加单击事件（这个按钮是我自己加的）
		$("#searchActivityBtn").click(function () {
			//清除全选复选框的勾
			$("#checkedAll").prop("checked", false);
			//收集参数
			var name = $.trim($("#search-activityName").val());
			//验证参数
			if(name == ""){
				alert("查询内容不能为空");
				return;
			}
			//向后端发起请求
			$.ajax({
				url: "workbench/clue/showActivityListByName.do",
				data: {
					"name": name
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					//字符串拼接，动态创建标签，展示市场活动列表
					var html = "";
					$.each(response, function (i, o) {
						html += '<tr>'
						html += '<td><input type="checkbox" value="'+o.id+'"/></td>'
						html += '<td>'+o.name+'</td>'
						html += '<td>'+o.startDate+'</td>'
						html += '<td>'+o.endDate+'</td>'
						html += '<td>'+o.owner+'</td>'
						html += '</tr>'
					});
					$("#activityListTB").html(html);
				}
			});
		});

		//给全选复选框添加事件
		$("#checkedAll").click(function () {
			$("#activityListTB input[type='checkbox']").prop("checked", this.checked);
		});
		//给所有市场活动复选框添加单击事件，当所有市场活动复选框选上后，全选复选框选上。
		$("#activityListTB").on("click", "input[type='checkbox']", function () {
			if($("#activityListTB input[type='checkbox']").size() == $("#activityListTB input[type='checkbox']:checked").size()){
				$("#checkedAll").prop("checked", true);
			}else{
				$("#checkedAll").prop("checked", false);
			}
		});

		//给关联市场活动的模态窗口中的 关联按钮 添加单击事件
		$("#boundActivityBtn").click(function(){
			//收集参数,
			var clueId = $("#hidden-id").val();
			var activityCheckBoxList = $("#activityListTB input[type='checkbox']:checked");

			//拼接请求参数字符串
			var param = "clueId=" + clueId + "&"
			$.each(activityCheckBoxList, function () {
				param += "activityId=" + this.value + "&";
			});
			param = param.substr(0, param.length - 1);

			//向后端发起请求，关联市场活动和线索
			$.ajax({
				url: "workbench/clue/createClueActivityRelation.do",
				data: param,
				type: "get",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//添加关联成功，关闭模态窗口，刷新市场活动列表
						showActivityList();
						$("#bundModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给所有 解除关联 按钮添加单击事件
		$("#activitiesTB").on("click", "a", function () {
			//收集参数
			var clueId = $("#hidden-id").val();
			var activityId = $(this).attr("activityId");

			//向后端发起请求
			$.ajax({
				url: "workbench/clue/unboundClueActivityRelation.do",
				data: {
					"clueId": clueId,
					"activityId": activityId
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//解除关联成功，刷新市场活动列表
						showActivityList();
					}else{
						alert(response.message);
					}
				}
			});
		});
		/*
		* 未完成：
		* 	1.跳转到详情页时，展示线索备注列表✔
		* 	2.跳转到详情页时，展示市场活动列表√
		* 	3.点击保存，刷新线索备注列表✔
		* 	4.给备注增加修改功能。✔
		* 	5.给备注增加删除功能。✔
		* 	6.搜索市场活动✔
		* */

	});

	//展示市场活动列表
	function showActivityList() {
		//收集参数
		var clueId = $("#hidden-id").val();
		//向后端发起请求
		$.ajax({
			url: "workbench/clue/showActivityList.do",
			data: {
				"clueId": clueId
			},
			type: "post",
			dataType: "json",
			success: function (response) {
				//字符串拼接
				var html = "";
				$.each(response, function (i, o) {
					html += '<tr>';
					html += '<td>'+o.name+'</td>';
					html += '<td>'+o.startDate+'</td>';
					html += '<td>'+o.endDate+'</td>';
					html += '<td>'+o.owner+'</td>';
					html += '<td><a href="javascript:void(0);" activityId="'+o.id+'" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html += '</tr>';
				});
				//清空原来的市场活动列表
				$("#activitiesTB").empty();
				//添加市场活动列表标签
				$("#activitiesTB").html(html);
			}
		});
	}

	//展示线索备注列表
	function showClueRemarkList(){
		//收集参数
		var clueId = $("#hidden-id").val();
		var fullname = $("#show-fullname").text();
		var company = $("#show-company").text();
		//向后端发起请求
		$.ajax({
			url: "workbench/clue/showClueRemarkList.do",
			data: {
				"clueId": clueId
			},
			type: "post",
			dataType: "json",
			success: function (response) {
				var html = "";
				$.each(response, function(i, o){
					html += '<div class="remarkDiv" id="div_'+o.id+'" style="height: 60px;">';
					html += '<img title="'+o.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+o.noteContent+'</h5>';
					html += '<font color="gray">线索</font> <font color="gray">-</font> <b>'+fullname+'-'+company+'</b> <small style="color: gray;">';
					html += o.editFlag == 0 ? (o.createTime + '由' + o.createBy + '创建</small>') : (o.editTime + '由' + o.editBy + '修改</small>');
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" name="updateA" remarkId="'+o.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" name="deleteA" remarkId="'+o.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				});
				//清除原来的线索备注列表
				$("#clueRemarkListDiv div[class='remarkDiv']").remove();
				//追加标签
				$("#remarkDiv").before(html);
				//清空输入框
				$("#remark").val("");
			}
		});
	}



</script>

</head>
<body>

	<!-- 修改线索备注的模态窗口 -->
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

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<%--保存线索id--%>
		<input type="hidden" id="clueId">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="search-activityName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
							<input type="button" id="searchActivityBtn" value="查询">
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="checkedAll"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityListTB">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="boundActivityBtn">关联</button>
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
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='convert.html';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>

		</div>
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<input type="hidden" id="hidden-id" value="${clue.id}">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="show-fullname">${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="show-company">${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>

	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;" id="clueRemarkListDiv">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${clueRemarks}" var="cr">
			<div class="remarkDiv" id="div_${cr.id}" style="height: 60px;">
				<img title="${cr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${cr.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${cr.editFlag == 0 ? cr.createTime : cr.editTime} 由${cr.editFlag == 0 ? cr.createBy : cr.editBy}${cr.editFlag == 0 ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="updateA" remarkId="${cr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkId="${cr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>

		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button type="button" class="btn btn-primary" id="saveCreateClueRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>

	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activitiesTB">
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					<c:forEach items="${activities}" var="activity">
						<tr>
							<td>${activity.name}</td>
							<td>${activity.startDate}</td>
							<td>${activity.endDate}</td>
							<td>${activity.owner}</td>
							<td><a href="javascript:void(0);" activityId="${activity.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>

			<div>
				<a href="javascript:void(0);" data-toggle="modal" name="boundActivityA" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>


	<div style="height: 200px;"></div>
</body>
</html>
