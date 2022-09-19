<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" language="java" %>
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

		$("#contactsRemarkListDiv").on("mouseover", ".remarkDiv", function () {
			$(this).children("div").children("div").show();
		});

		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/

		$("#contactsRemarkListDiv").on("mouseout", ".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		});

		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/

		$("#contactsRemarkListDiv").on("mouseover", ".myHref", function () {
			$(this).children("span").css("color","red");
		});

		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/

		$("#contactsRemarkListDiv").on("mouseout", ".myHref", function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/

		//给创建备注的 保存按钮 添加单击事件
		$("#saveCreateContactsRemarkBtn").click(function () {
			//收集参数
			var noteContent = $.trim($("#remark").val());
			if(noteContent == ""){
				alert("请输入备注内容");
				return;
			}
			var contactsId = $("#hidden-contactsId").val();

			//向后端发起请求
			$.ajax({
				url: "workbench/contacts/saveCreateContactsRemark.do",
				data: {
					"noteContent": noteContent,
					"contactsId": contactsId
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//新增联系人备注成功
						//刷新备注列表
						showContactsRemarkList();
						//清空备注输入框
						$("#remark").val("");
					}
				}
			});
		});

		//给修改联系人备注的 图标 添加单击事件
		$("#contactsRemarkListDiv").on("click", "a[name='updateA']", function () {
			//收集参数：备注的id，noteContent
			var id = $(this).attr("remarkId");
			var noteContent = $("#h5_"+id).text();
			//把id保存到模态窗口中的隐藏标签中
			$("#contactsRemarkId").val(id);
			//把noteContent填到模态窗口的输入框中
			$("#edit-noteContent").val(noteContent);
			//打开修改联系人备注的模态窗口
			$("#editRemarkModal").modal("show");
		});

		//给 修改联系人的模态窗口中的 更新按钮 添加单击事件
		$("#updateContactsRemarkBtn").click(function () {
			//收集参数：备注的id，noteContent
			var id = $("#contactsRemarkId").val();
			var noteContent = $("#edit-noteContent").val();
			//向后端发起请求
			$.ajax({
				url: "workbench/contacts/saveEditAContactsRemark.do",
				data: {
					"id": id,
					"noteContent": noteContent
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//修改联系人备注成功
						//刷新备注列表
						showContactsRemarkList();
						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给 联系人备注的 删除图标 添加单击事件
		$("#contactsRemarkListDiv").on("click", "a[name='deleteA']", function () {
			if(confirm("确定要删除这条备注吗？")){
				//收集参数：备注的id
				var id = $(this).attr("remarkId");
				//向后端发起请求
				$.ajax({
					url: "workbench/contacts/deleteAContactsRemark.do",
					data: {
						"id": id
					},
					type: "post",
					dataType: "json",
					success: function (response) {
						if(response.code == "1"){
							//删除联系人备注成功
							//刷新联系人备注列表
							showContactsRemarkList();
						}else{
							alert(response.message);
						}
					}
				});
			}
		});

		//给交易的 删除按钮 添加单击事件
		$("#tranListTB").on("click", "a[name='deleteTranA']", function () {
			if(confirm("确定要删除这条交易吗？")){
				//收集参数：交易id
				var id = $(this).attr("tranId");
				//向后端发起请求
				$.ajax({
					url: "workbench/contacts/deleteTranById.do",
					data: {
						"id": id
					},
					type: "post",
					dataType: "json",
					success: function (response) {
						if(response.code == "1"){
							//删除交易成功
							//刷新交易列表
							showTranList();
						}else{
							alert(response.message);
						}
					}
				});
			}
		});

		//给 关联市场活动的模态窗口中的 全选和单选框 添加单击事件
		$("#qx").click(function () {
			$("#activityListTB input").prop("checked", this.checked);
		});
		$("#activityListTB").on("click", "input", function () {
			if($("#activityListTB input").size() == $("#activityListTB input:checked").size()){
				$("#qx").prop("checked", true);
			}else{
				$("#qx").prop("checked", false);
			}
		});

		//给 关联市场活动的 A标签添加单击事件
		$("a[name='createContactsActivityRelationA']").click(function () {
			//清空输入框
			$("#searchActivityName").val("");
			//清空全选框
			$("#qx").prop("checked", false);
			//清空市场活动列表
			$("#activityListTB").empty();
			//打开模态窗口
			$("#bundActivityModal").modal("show");
		});

		//给关联市场活动的模态窗口中的 输入框 添加键盘弹起事件
		$("#searchActivityName").keyup(function () {
			//收集参数：用户输入的市场活动名称、联系人id
			var name =  $.trim(this.value);
			var contactsId = $("#hidden-contactsId").val();
			//向后端发起请求
			$.ajax({
				url: "workbench/contacts/searchActivityListForContactsActivityRelation.do",
				data: {
					"name": name,
					"contactsId": contactsId
				},
				type: "post",
				dataType: "json",
				success: function (activityList) {
					//字符串拼接，组装html标签，展示市场活动列表
					var html = "";
					$.each(activityList, function (i, o) {
						html += '<tr>';
						html += '<td><input type="checkbox" value="'+o.id+'"/></td>';
						html += '<td>'+o.name+'</td>';
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

		//给 关联市场活动的模态窗口的 关联按钮 添加单击事件
		$("#saveCreateContactsActivityRelationBtn").click(function () {
			//收集参数：选中的市场活动id，联系人id
			var checkedBox = $("#activityListTB input:checked");
			if(checkedBox.size() == 0){
				alert("至少需要选择一个市场活动进行关联操作");
				return;
			}
			var contactsId = $("#hidden-contactsId").val();
			//字符串拼接，组装请求参数
			param = "contactsId=" + contactsId + "&";
			$.each(checkedBox, function () {
				param += "activityId=" + this.value + "&";
			});
			//向后端发起请求
			$.ajax({
				url: "workbench/contacts/saveCreateContactsActivityRelation.do",
				data: param,
				type: "get",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//新增关联关系成功
						//刷新市场活动列表
						showActivityList();
						//关闭模态窗口
						$("#bundActivityModal").modal("hide");
					}
				}
			});
		});

		//给 解除关联 按钮添加单击事件
		$("#showActivityListTB").on("click", "a[name='deleteContactsActivityRelationA']", function () {
			//收集参数：市场活动id
			var activityId = $(this).attr("activityId");
			//保存数据到解绑的模态窗口中的隐藏标签中
			$("#hidden-unbundActivityId").val(activityId);
			//打开解绑的模态窗口
			$("#unbundActivityModal").modal("show");
		});

		//给 解绑的模态窗口的 解除按钮 添加单击事件
		$("#unbundContactsActivityRelationBtn").click(function () {
			//收集参数：市场活动id，联系人id
			var activityId = $("#hidden-unbundActivityId").val();
			var contactsId = $("#hidden-contactsId").val();
			//向后端发起请求
			$.ajax({
				url: "workbench/contacts/unbundContactsActivityRelation.do",
				data: {
					"activityId": activityId,
					"contactsId": contactsId
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//解绑成功，
						//刷新市场活动列表
						showActivityList();
						//关闭模态窗口
						$("#unbundActivityModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});
	});

	//展示市场活动列表
	function showActivityList(){
		//收集参数：联系人id
		var contactsId = $("#hidden-contactsId").val();
		//向后端发起请求
		$.ajax({
			url: "workbench/contacts/showActivityListForDetail.do",
			data: {
				"contactsId": contactsId
			},
			type: "post",
			dataType: "json",
			success: function (activityList) {
				//字符串拼接，组装html标签，展示市场活动列表
				var html = "";
				$.each(activityList, function (i, o) {
					html += '<tr>';
					html += '<td><a href="activity/detail.html" style="text-decoration: none;">'+o.name+'</a></td>';
					html += '<td>'+o.startDate+'</td>';
					html += '<td>'+o.endDate+'</td>';
					html += '<td>'+o.owner+'</td>';
					html += '<td><a href="javascript:void(0);" name="deleteContactsActivityRelationA" activityId="'+o.id+'" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html += '</tr>';
				});
				//展示市场活动列表
				$("#showActivityListTB").html(html);
			}
		});
	}

	//展示交易列表
	function showTranList(){
		//获取参数：联系人id
		var contactsId = $("#hidden-contactsId").val();
		//向后端发起请求
		$.ajax({
			url: "workbench/contacts/showTranList.do",
			data: {
				"contactsId":contactsId
			},
			type: "post",
			dataType: "json",
			success: function (tranList) {
				//字符串拼接，组装html标签，展示交易列表
				var html = "";
				$.each(tranList, function(i, o){
					html += '<tr>';
					html += '<td><a href="workbench/transaction/toTranDetail.do?id='+o.id+'" style="text-decoration: none;">'+o.name+'</a></td>';
					html += '<td>'+o.money+'</td>';
					html += '<td>'+o.stage+'</td>';
					html += '<td>'+o.possibility+'</td>';
					html += '<td>'+o.expectedDate+'</td>';
					html += '<td>'+o.type+'</td>';
					html += '<td><a name="deleteTranA" tranId="'+o.id+'" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
					html += '</tr>';
				});
				//展示交易列表
				$("#tranListTB").html(html);
			}
		});
	}

	//展示联系人备注列表
	function showContactsRemarkList() {
		//清除原先的备注列表
		$("#contactsRemarkListDiv div[class='remarkDiv']").remove();
		//收集参数
		var contactsId = $("#hidden-contactsId").val();
		//向后端发起请求
		$.ajax({
			url: "workbench/contacts/showContactsRemarkList.do",
			data: {
				"contactsId": contactsId
			},
			type: "post",
			dataType: "json",
			success: function (contactsRemarkList) {
				//字符串拼接，组装html标签，展示联系人备注列表
				var html = "";
				$.each(contactsRemarkList, function (i, o) {
					html += '<div class="remarkDiv" style="height: 60px;">';
					html += '<img title="'+o.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="h5_'+o.id+'">'+o.noteContent+'</h5>';
					html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${contacts.fullname}${contacts.appellation}-${contacts.customerId}</b> <small style="color: gray;"> ';
					html += (o.editFlag == 0 ? o.createTime : o.editTime)+' 由'+(o.editFlag == 0 ? o.createBy : o.editBy)+(o.editFlag == 0 ? "创建" : "修改")+'</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" name="updateA" remarkId="'+o.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" name="deleteA" remarkId="'+o.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				});
				//展示联系人备注列表
				$("#remarkDiv").before(html);
			}
		});
	}

</script>

</head>
<body>
	<!-- 修改联系人备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="contactsRemarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myRemarkModalLabel">修改备注</h4>
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
					<button type="button" class="btn btn-primary" id="updateContactsRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
					<%--保存需要解绑关联关系的市场活动id--%>
					<input type="hidden" id="hidden-unbundActivityId">
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="unbundContactsActivityRelationBtn">解除</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
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
						    <input type="text" class="form-control" id="searchActivityName" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="qx"/></td>
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
					<button type="button" class="btn btn-primary" id="saveCreateContactsActivityRelationBtn">关联</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
								  <%--<option selected>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
									  <c:forEach items="${userList}" var="user">
										  <option value="${user.id}">${user.name}</option>
									  </c:forEach>
								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
								  <option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								  <%--<option selected>广告</option>
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
						</div>

						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								  <%--<option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address1">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
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
			<h3>${contacts.fullname}${contacts.appellation} <small> - ${contacts.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<%--保存该联系人的id到隐藏标签中--%>
		<input type="hidden" id="hidden-contactsId" value="${contacts.id}">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.fullname}${contacts.appellation}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contacts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contacts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contacts.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contacts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contacts.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contacts.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${contacts.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div id="contactsRemarkListDiv" style="position: relative; top: 20px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${contactsRemarkList}" var="contactsRemark">
			<div class="remarkDiv" style="height: 60px;">
				<img title="${contactsRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="h5_${contactsRemark.id}">${contactsRemark.noteContent}</h5>
					<font color="gray">联系人</font> <font color="gray">-</font> <b>${contacts.fullname}${contacts.appellation}-${contacts.customerId}</b> <small style="color: gray;"> ${contactsRemark.editFlag == "0" ? contactsRemark.createTime : contactsRemark.editTime} 由${contactsRemark.editFlag == "0" ? contactsRemark.createBy : contactsRemark.editBy}${contactsRemark.editFlag == "0" ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="updateA" remarkId="${contactsRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkId="${contactsRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>

		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button type="button" id="saveCreateContactsRemarkBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>

	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tranListTB">
						<c:forEach items="${tranList}" var="tran">
							<tr>
								<td><a href="workbench/transaction/toTranDetail.do?id=${tran.id}" style="text-decoration: none;">${tran.name}</a></td>
								<td>${tran.money}</td>
								<td>${tran.stage}</td>
								<td>${tran.possibility}</td>
								<td>${tran.expectedDate}</td>
								<td>${tran.type}</td>
								<td><a name="deleteTranA" tranId="${tran.id}" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td><a href="transaction/detail.html" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>

			<div>
				<a href="workbench/transaction/toTranSave.do" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>

	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="showActivityListTB">
						<c:forEach items="${activityList}" var="activity">
							<tr>
								<td><a href="activity/detail.html" style="text-decoration: none;">${activity.name}</a></td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a href="javascript:void(0);" name="deleteContactsActivityRelationA" activityId="${activity.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td><a href="activity/detail.html" style="text-decoration: none;">发传单</a></td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>

			<div>
				<a href="javascript:void(0);" name="createContactsActivityRelationA" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>


	<div style="height: 200px;"></div>
</body>
</html>