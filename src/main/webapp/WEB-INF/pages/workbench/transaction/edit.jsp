<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript">

	$(function () {

		//添加时间插件
		$(".mydate").datetimepicker({
			language: "en",
			format: "yyyy-mm-dd",
			autoclose: true,
			minView: "month",
			initialDate: new Date(),
			todayBtn: true,
			clearBtn: true
		});

		//加载部分数据：所有者、阶段、类型、来源
		$("#edit-owner").val("${tran.owner}");
		$("#edit-stage").val("${tran.stage}");
		$("#edit-type").val("${tran.type}");
		$("#edit-source").val("${tran.source}");

		//给 阶段 下拉框 添加改变事件
		$("#edit-stage").change(function(){
			//收集参数：阶段的名称
			var stageName = $(this).find("option:selected").text();
			//向后端发起请求
			$.ajax({
				url: "workbench/transaction/getPossibilityByStageName.do",
				data: {
					"stageName": stageName
				},
				type: "post",
				dataType: "json",
				success: function (possibility) {
					//填充可能性数据
					$("#edit-possibility").val(possibility);
				}
			});
		});

		//给 保存按钮 添加单击事件
		$("#saveEditTranBtn").click(function () {
			//收集参数
			var id = $("#hidden-tranId").val();
			var owner = $("#edit-owner").val();
			var money = $.trim($("#edit-money").val());
			var name = $.trim($("#edit-name").val());
			var expectedDate = $("#edit-expectedDate").val();
			var customerName = $.trim($("#edit-customerName").val());
			var stage = $("#edit-stage").val();
			var type = $("#edit-type").val();
			var source = $("#edit-source").val();
			var activityId = $("#hidden-editActivityId").val();
			var contactsId = $("#hidden-editContactsId").val();
			var description = $("#edit-description").val();
			var contactSummary = $("#edit-contactSummary").val();
			var nextContactTime = $("#edit-nextContactTime").val();

			//验证数据的合法性
			var regxStr = /^(([1-9]\d*)|0)$/;
			if(money != "" && !regxStr.test(money)){
				alert("金额格式不符合要求");
				return;
			}
			if(name == ""){
				alert("名称不能为空");
				return;
			}
			if(expectedDate == ""){
				alert("预计成交日期不能为空");
				return;
			}
			if(customerName == ""){
				alert("客户名称不能为空");
				return;
			}
			if(stage == ""){
				alert("阶段不能为空");
				return;
			}
			//向后端发起请求
			$.ajax({
				url: "workbench/transaction/saveEditTran.do",
				data: {
					"id": id,
					"owner": owner,
					"money": money,
					"name": name,
					"expectedDate": expectedDate,
					"customerName": customerName,
					"stage": stage,
					"type": type,
					"source": source,
					"activityId": activityId,
					"contactsId": contactsId,
					"description": description,
					"contactSummary": contactSummary,
					"nextContactTime": nextContactTime
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//成功，跳转到交易列表页index
						window.location.href = "workbench/transaction/toTranIndex.do"
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给 取消按钮 添加单击事件
		$("#cancelSaveEditTranBtn").click(function () {
			window.history.back();
		});

		//给 查找联系人名称的 放大镜 添加单击事件
		$("a[name='searchContactsA']").click(function () {
			//清空 模态窗口的 搜索框
			$("#searchContactsName").val("");
			//清空 联系人列表
			$("#contactsListTB").empty();
			//打开模态窗口
			$("#findContacts").modal("show");
		});

		//给 搜索联系人的 搜索框 添加键盘弹起事件
		$("#searchContactsName").keyup(function () {
			//收集参数：用户输入的联系人名称
			var customerName = $.trim(this.value);
			//向后端发起请求
			$.ajax({
				url: "workbench/transaction/showContactsListByName.do",
				data: {
					"name": customerName
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					//拼接字符串，组装html标签，
					var html = "";
					$.each(response, function (i, o) {
						html += '<tr>';
						html += '<td><input type="radio" value="'+o.id+'" name="activity"/></td>';
						html += '<td id="td_'+o.id+'">'+o.fullname+'</td>';
						html += '<td>'+o.email+'</td>';
						html += '<td>'+o.mphone+'</td>';
						html += '</tr>';
					});
					//展示联系人列表
					$("#contactsListTB").html(html);
				}
			});
		});

		//给 查找联系人模态窗口中的 联系人列表中的 单选框 添加单击事件
		$("#contactsListTB").on("click", "input", function () {
			//收集参数
			var id = this.value;
			var name = $("#td_"+id).text();

			//展示名称,id保存到隐藏标签
			$("#edit-contactsName").val(name);
			$("#hidden-editContactsId").val(id);

			//关闭模态窗口
			$("#findContacts").modal("hide");
		});

		//给 搜索市场活动的 放大镜 添加单击事件
		$("a[name='searchActivityA']").click(function () {
			//清空模态窗口中的文本框内容
			$("#searchActivityName").val("");
			//清空市场活动列表
			$("#activityListTB").empty();
			//打开模态窗口
			$("#findMarketActivity").modal("show");
		});

		//给 查找市场活动的模态窗口 中的 搜索框添加键盘弹起事件
		$("#searchActivityName").keyup(function () {
			//收集参数
			var name = $.trim(this.value);
			//向后端发起请求
			$.ajax({
				url: "workbench/transaction/showActivityListByName.do",
				data: {
					"name": name
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					//字符串拼接，组装html标签，
					var html = "";
					$.each(response, function (i, o) {
						html += '<tr>';
						html += '<td><input type="radio" value="'+o.id+'" name="activity"/></td>';
						html += '<td id="td_'+o.id+'">'+o.name+'</td>';
						html += '<td>'+o.startDate+'</td>';
						html += '<td>'+o.endDate+'</td>';
						html += '<td>'+o.owner+'</td>';
						html += '</tr>';
					});
					//展示市场活动列表
					$("#activityListTB").html(html);
				}
			});
		});

		//给 查找市场活动的模态窗口 中的 市场活动 单选框 添加单击事件
		$("#activityListTB").on("click", "input", function () {
			//收集参数
			var id = this.value;
			var name = $("#td_"+id).text(); //$("#td_1ea8c7950f9341b7b29c69b5dc79a083")
			//在 创建交易 页面的 市场活动源 后面的文本框输入 名称，并把id保存到该文本标签中
			$("#edit-activityName").val(name);
			$("#hidden-editActivityId").val(id);
			//关闭模态窗口
			$("#findMarketActivity").modal("hide");
		});


	});
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivityName" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
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

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchContactsName" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsListTB">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>修改交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveEditTranBtn">保存</button>
			<button type="button" class="btn btn-default" id="cancelSaveEditTranBtn">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<%--保存需要修改的交易的id--%>
		<input type="hidden" id="hidden-tranId" value="${tran.id}">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner">
					<c:forEach items="${userList}" var="user">
						<option value="${user.id}">${user.name}</option>
					</c:forEach>
				  <%--<option>zhangsan</option>
				  <option>lisi</option>
				  <option>wangwu</option>--%>
				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money" value="${tran.money}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" value="${tran.name}">
			</div>
			<label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="edit-expectedDate" value="${tran.expectedDate}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="hidden-editCustomerId" value="${tran.customerId}">
				<input type="text" class="form-control" id="edit-customerName" value="${customerName}" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="stage">
					  <option value="${stage.id}">${stage.value}</option>
				  </c:forEach>
			  	<%--<option>资质审查</option>
			  	<option>需求分析</option>
			  	<option>价值建议</option>
			  	<option>确定决策者</option>
			  	<option>提案/报价</option>
			  	<option>谈判/复审</option>
			  	<option>成交</option>
			  	<option>丢失的线索</option>
			  	<option>因竞争丢失关闭</option>--%>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="type">
						<option value="${type.id}">${type.value}</option>
					</c:forEach>
				  <%--<option>已有业务</option>
				  <option>新业务</option>--%>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" value="${tran.possibility}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source">
				  <option></option>
					<c:forEach items="${sourceList}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				  <%--<option>广告</option>
				  <option>推销电话</option>
				  <option>员工介绍</option>
				  <option>外部介绍</option>
				  <option>在线商场</option>
				  <option>合作伙伴</option>
				  <option>公开媒介</option>
				  <option>销售邮件</option>
				  <option>合作伙伴研讨会</option>
				  <option>内部研讨会</option>
				  <option>交易会</option>
				  <option>web下载</option>
				  <option>web调研</option>
				  <option>聊天</option>--%>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" name="searchActivityA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="hidden-editActivityId" value="${tran.activityId}">
				<input type="text" class="form-control" id="edit-activityName" value="${activityName}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" name="searchContactsA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="hidden-editContactsId" value="${tran.contactsId}">
				<input type="text" class="form-control" id="edit-contactsName" value="${contactsName}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description">${tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary">${tran.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="edit-nextContactTime" value="${tran.nextContactTime}" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>