<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){

		//添加日期插件，用作创建交易时，选择预计成交日期
		$(".mydate").datetimepicker({
			language: "en",
			format: "yyyy-mm-dd",
			autoclose: true,
			minView: "month",
			initialDate: new Date(),
			todayBtn: true,
			clearBtn: true
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//给 市场活动源的 放大镜 添加单击事件
		$("a[name='searchActivityA']").click(function(){
			//清空搜索框
			$("#searchActivityList").val("");
			//清空市场活动列表
			$("#activityListTB").empty();
			//展示 搜索市场活动的模态窗口
			$("#searchActivityModal").modal("show");
		});

		//给搜索市场活动的模态窗口中的 搜索文本框 添加键盘弹起事件
		$("#searchActivityList").keyup(function () {
			//收集参数
			var name = $.trim(this.value);
			var clueId = $("#hidden-clueId").val();
			//向后端发起请求
			$.ajax({
				url: "workbench/clue/showActivityListByNameAndClueId.do",
				data: {
					"name": name,
					"clueId": clueId
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					var html = "";
					$.each(response, function (i, o) {
						html += '<tr>'
						html += '<td><input type="radio" value="'+o.id+'" activityName="'+o.name+'" name="activity"/></td>'
						html += '<td>'+o.name+'</td>'
						html += '<td>'+o.startDate+'</td>'
						html += '<td>'+o.endDate+'</td>'
						html += '<td>'+o.owner+'</td>'
						html += '</tr>'
					});
					//展示市场活动列表
					$("#activityListTB").html(html);
				}
			});
		});

		//给 市场活动前面的 圆圈单选框 添加单击事件
		$("#activityListTB").on("click", "input", function () {
			//收集参数
			var activityName = $(this).attr("activityName");
			var activityId = this.value;
			//显示到转换页面,保存id到隐藏标签
			$("#activity").val(activityName);
			$("#hidden-activityId").val(activityId);
			//关闭模态窗口
			$("#searchActivityModal").modal("hide");
		});

		//给 转换 按钮添加单击事件
		$("#saveConvertBtn").click(function () {
			//收集参数
			var clueId = $("#hidden-clueId").val();
			var isCreateTran = $("#isCreateTransaction").prop("checked");

			//这里勾选了创建交易，才收集交易相关的参数
			if(isCreateTran){
				money = $.trim($("#tran-money").val());
				name = $.trim($("#tran-name").val());
				expectedDate = $("#tran-expectedDate").val();
				stage = $("#stage").val();
				activityId = $("#hidden-activityId").val();
				//表单验证
				//金额是非负整数
				var rexStr = /^(([1-9]\d*)|0)$/;
				if(!rexStr.test(money)){
					alert("输入的金额非法，请重新输入");
					return;
				}
				//向后端发起请求
				$.ajax({
					url: "workbench/clue/saveConvert.do",
					data: {
						"clueId": clueId,
						"isCreateTran": isCreateTran,
						"money": money,
						"name": name,
						"expectedDate": expectedDate,
						"stage": stage,
						"activityId": activityId,
					},
					type: "post",
					dataType: "json",
					success: function (response) {
						if(response.code == "1"){
							//代表转换成功，跳转到线索主页面
							window.location.href = "workbench/clue/index.do";
						}else{
							//代表转换失败，提示信息,页面不跳转
							alert(response.message);
						}
					}
				});
			}else{
				//不需要收集交易相关的参数
				//向后端发起请求
				$.ajax({
					url: "workbench/clue/saveConvert.do",
					data: {
						"clueId": clueId,
						"isCreateTran": isCreateTran,
					},
					type: "post",
					dataType: "json",
					success: function (response) {
						if(response.code == "1"){
							//代表转换成功，跳转到线索主页面
							window.location.href = "workbench/clue/index.do";
						}else{
							//代表转换失败，提示信息,页面不跳转
							alert(response.message);
						}
					}
				});
			}
		});
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchActivityList" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityListTB">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<input type="hidden" id="hidden-clueId" value="${clue.id}">
	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="tran-money">金额</label>
		    <input type="text" class="form-control" id="tran-money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tran-name">交易名称</label>
		    <input type="text" class="form-control" id="tran-name" value="${clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tran-expectedDate">预计成交日期</label>
		    <input type="text" class="form-control mydate" id="tran-expectedDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
		    	<%--<option>资质审查</option>
		    	<option>需求分析</option>
		    	<option>价值建议</option>
		    	<option>确定决策者</option>
		    	<option>提案/报价</option>
		    	<option>谈判/复审</option>
		    	<option>成交</option>
		    	<option>丢失的线索</option>
		    	<option>因竞争丢失关闭</option>--%>
				<c:forEach items="${stageList}" var="stage">
					<option value="${stage.id}">${stage.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" name="searchActivityA" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			  <input type="hidden" id="hidden-activityId">
			  <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" value="转换" id="saveConvertBtn">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>