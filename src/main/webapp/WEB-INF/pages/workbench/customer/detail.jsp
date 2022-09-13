<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		//添加日期插件
		$(".mydate").datetimepicker({
			language: "en",
			format: "yyyy-mm-dd",
			autoclose: true,
			minView: "month",
			initialDate: new Date(),
			todayBtn: true,
			clearBtn: true
		});

		//客户名称添加自动补全插件
		$("#create-customerName").typeahead({
			source: function (query, process) {
				$.post(
						"workbench/customer/showCustomerNameListByNameForContactCreate.do",
						{ "name" : query },
						function (data) {
							//alert(data);
							process(data);
						},
						"json"
				);
			},
			delay: 1500
		});

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

		$("#customerRemarkListDiv").on("mouseover", ".remarkDiv", function () {
			$(this).children("div").children("div").show();
		});

		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/

		$("#customerRemarkListDiv").on("mouseout", ".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		});

		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/

		$("#customerRemarkListDiv").on("mouseover", ".myHref", function () {
			$(this).children("span").css("color","red");
		});
		
		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/

		$("#customerRemarkListDiv").on("mouseout", ".myHref", function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		
		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/

		//给创建客户备注的 保存 按钮添加单击事件
		$("#saveCreateCustomerRemarkBtn").click(function () {
			//收集参数：备注信息、客户id
			var customerId = $("#hidden-customerId").val();
			var noteContent = $.trim($("#remark").val());
			//向后端发起请求
			$.ajax({
				url: "workbench/customer/saveCreateCustomerRemark.do",
				data: {
					"customerId": customerId,
					"noteContent": noteContent
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//保存客户备注成功
						//刷新客户备注列表
						showCustomerRemarkList();
						//清空文本框
						$("#remark").val("");
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给修改客户备注的图标添加单击事件
		$("#customerRemarkListDiv").on("click", "a[name='updateA']", function(){
			//拿到备注id并保存到隐藏标签中
			var remarkId = $(this).attr("remarkId");
			$("#hidden-customerRemarkId").val(remarkId);
			//获取需要修改的备注内容，并填写到修改备注的模态窗口中的文本框中
			var noteConent = $("#div_"+remarkId+" h5").text(); //$("#div_4408fa357cae44058c83a0b2090455a1 h5").text()
			$("#edit-noteContent").val(noteConent);
			//打开修改客户备注的模态窗口
			$("#editRemarkModal").modal("show");
		});

		//给 修改客户备注的模态窗口中的 更新 按钮添加单击事件
		$("#updateRemarkBtn").click(function () {
			//收集参数
			var id = $("#hidden-customerRemarkId").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			//向后端发起请求
			$.ajax({
				url: "workbench/customer/editCustomerRemarkInCustomerDetail.do",
				data: {
					"id": id,
					"noteContent": noteContent
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//修改成功
						//刷新客户备注列表
						showCustomerRemarkList();
						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给所有删除客户备注的 图标 添加单击事件
		$("#customerRemarkListDiv").on("click", "a[name='deleteA']", function () {
			if(confirm("确认删除客户备注信息吗？")){
				//收集参数
				var id = $(this).attr("remarkId");
				//向后端发起请求
				$.ajax({
					url: "workbench/customer/deleteCustomerRemarkById.do",
					data: {
						"id": id
					},
					type: "post",
					dataType: "json",
					success: function (response) {
						if(response.code == "1"){
							//删除客户备注成功
							//刷新客户备注列表
							showCustomerRemarkList();
						}else{
							alert(response.message);
						}
					}
				});
			}
		});

		//给交易的 删除 按钮添加单击事件
		$("#tranListTB").on("click", "a[name='deleteTranA']", function () {
			//收集参数
			var id = $(this).attr("tranId");
			//把值保存到模态窗口中的隐藏标签中
			$("#hidden-tranId").val(id);
			//打开模态窗口
			$("#removeTransactionModal").modal("show");
		});

		//给删除交易模态窗口中的 删除 按钮添加单击事件
		$("#deleteTranBtn").click(function () {
			//收集参数
			var id = $("#hidden-tranId").val();
			//向后端发起请求
			$.ajax({
				url: "workbench/customer/deleteTranAtCustomerDetail.do",
				data: {
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//成功，刷新交易列表
						showTranList();
						//关闭模态窗口
						$("#removeTransactionModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给 创建联系人模态窗口 中的 保存 按钮添加单击事件
		$("#saveCreateCustomerBtn").click(function () {
			//收集参数
			var owner = $("#create-contactsOwner").val();
			var source = $("#create-clueSource").val();
			var fullname = $.trim($("#create-fullname").val());
			var appellation = $("#create-appellation").val();
			var job = $.trim($("#create-job").val());
			var mphone = $.trim($("#create-mphone").val());
			var email = $.trim($("#create-email").val());
			//临时放在customerId中，方便后端存取数据
			var customerId = $.trim($("#create-customerName").val());
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $.trim($("#create-nextContactTime").val());
			var address = $.trim($("#create-address").val());

			//验证数据合法性
			if(fullname == ""){
				alert("姓名不能为空");
				return;
			}
			var regxStr = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(mphone != "" && !regxStr.test(mphone)){
				alert("手机格式有误，请重新输入");
				return;
			}
			regxStr = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(email != "" && !regxStr.test(email)){
				alert("邮箱格式有误，请重新输入");
				return;
			}

			//向后端发起请求
			$.ajax({
				url: "workbench/customer/saveCreateContactsAtCustomerDetail.do",
				data: {
					"owner": owner,
					"source": source,
					"fullname": fullname,
					"appellation": appellation,
					"job": job,
					"mphone": mphone,
					"email": email,
					"customerId": customerId,
					"description": description,
					"contactSummary": contactSummary,
					"nextContactTime": nextContactTime,
					"address": address
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//新建联系人成功
						//刷新联系人列表
						showContactsList();
						//清空模态窗口中的表单内容
						$("#createContactsForm")[0].reset();
						//关闭模态窗口
						$("#createContactsModal").modal("hide");
					}else {
						alert(response.message);
					}
				}
			});
		});

		//给联系人列表中的 删除 按钮添加单击事件
		$("#contactsListTB").on("click", "a[name='deleteContactsA']", function () {
			//收集参数
			var contactsId = $(this).attr("contactsId");
			//把contactsId保存到隐藏标签中
			$("#hidden-contactsId").val(contactsId);
			//打开模态窗口
			$("#removeContactsModal").modal("show");
		});

		//给 删除联系人模态窗口中的 删除 按钮添加单击事件
		$("#deleteContactsBtn").click(function () {
			//收集参数
			var id = $("#hidden-contactsId").val();
			//向后端发起请求
			$.ajax({
				url: "workbench/customer/deleteContactsById.do",
				data: {
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//删除成功
						//刷新联系人列表
						showContactsList();
						//关闭模态窗口
						$("#removeContactsModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});
	});

	//展示联系人列表
	function showContactsList(){
		//收集参数
		var customerId = $("#hidden-customerId").val();
		//向后端发起请求
		$.ajax({
			url: "workbench/customer/showContactsList.do",
			data: {
				"customerId": customerId
			},
			type: "post",
			dataType: "json",
			success: function (response) {
				//拼接字符串，组装html标签
				var html = "";
				$.each(response, function(i, o){
					html += '<tr>';
					html += '<td><a href="contacts/detail.html" style="text-decoration: none;">'+o.fullname+'</a></td>';
					html += '<td>'+o.email+'</td>';
					html += '<td>'+o.mphone+'</td>';
					html += '<td><a href="javascript:void(0);" name="deleteContactsA" contactsId="'+o.id+'" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
					html += '</tr>';
				});
				$("#contactsListTB").html(html);
			}
		});

	}

	//展示交易列表
	function showTranList() {
		//收集参数
		var customerId = $("#hidden-customerId").val();
		//向后端发起请求
		$.ajax({
			url: "workbench/customer/showTranListByCustomerId.do",
			data: {
				"customerId": customerId
			},
			type: "post",
			dataType: "json",
			success: function (response) {
				//字符串拼接，组装html标签，
				var html = "";
				$.each(response, function (i, o) {
					html += '<tr>';
					html += '<td><a href="workbench/transaction/toTranDetail.do?id='+o.id+'" style="text-decoration: none;">'+o.name+'</a></td>';
					html += '<td>'+o.money+'</td>';
					html += '<td>'+o.stage+'</td>';
					html += '<td>90</td>';
					html += '<td>'+o.expectedDate+'</td>';
					html += '<td>'+o.type+'</td>';
					html += '<td><a href="javascript:void(0);" name="deleteTranA" tranId="'+o.id+'" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
					html += '</tr>';
				});
				//展示交易列表
				$("#tranListTB").html(html);
			}
		});
	}

	//展示客户备注列表
	function showCustomerRemarkList(){
		//收集参数：客户id
		var customerId = $("#hidden-customerId").val();
		//向后端发起请求
		$.ajax({
			url: "workbench/customer/showCustomerRemarkListInCustomerDetail.do",
			data: {
				"customerId": customerId
			},
			type: "post",
			dataType: "json",
			success: function (response) {
				//字符串拼接，组装html标签，展示客户备注列表
				var html = "";
				$.each(response, function (i, o) {
					html += '<div class="remarkDiv" id="div_'+o.id+'" style="height: 60px;">';
					html += '<img title="'+o.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+o.noteContent+'</h5>';
					html += '<font color="gray">客户</font> <font color="gray">-</font> <b>'+o.customerId+'</b> <small style="color: gray;">';
					html += (o.editFlag == 0 ? o.createTime : o.editTime)+' 由'+(o.editFlag == 0 ? o.createBy : o.editBy)+(o.editFlag == 0 ? "创建" : "修改")+'</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" name="updateA" remarkId="'+o.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" name="deleteA" remarkId="'+o.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				});
				//清楚原来的备注列表标签
				$("#customerRemarkListDiv div[class='remarkDiv']").remove();
				//填充标签,展示新的备注列表
				$("#remarkDiv").before(html);
			}
		});
	}
	
</script>

</head>
<body>

	<%--修改客户备注的模态窗口--%>
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 客户备注的id --%>
		<input type="hidden" id="hidden-customerRemarkId">
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

	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<input type="hidden" id="hidden-contactsId">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该联系人吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="deleteContactsBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
    <div class="modal fade" id="removeTransactionModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 30%;">
            <div class="modal-content">
				<input type="hidden" id="hidden-tranId">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title">删除交易</h4>
                </div>
                <div class="modal-body">
                    <p>您确定要删除该交易吗？</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-danger" id="deleteTranBtn">删除</button>
                </div>
            </div>
        </div>
    </div>
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createContactsForm">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
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
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <%--<option>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-birth" readonly>
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
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
                                    <input type="text" class="form-control mydate" id="create-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateCustomerBtn">保存</button>
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
			<h3>${customer.name} <small><a href="http://www.bjpowernode.com" target="_blank">${customer.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<input type="hidden" id="hidden-customerId" value="${customer.id}">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="customerRemarkListDiv" style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">客户</font> <font color="gray">-</font> <b>北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">客户</font> <font color="gray">-</font> <b>北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		<c:forEach items="${customerRemarkList}" var="cr">
			<div class="remarkDiv" id="div_${cr.id}" style="height: 60px;">
				<img title="${cr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${cr.noteContent}</h5>
					<font color="gray">客户</font> <font color="gray">-</font> <b>${cr.customerId}</b> <small style="color: gray;"> ${cr.editFlag == 0 ? cr.createTime : cr.editTime} 由${cr.editFlag == 0 ? cr.createBy : cr.editBy}${cr.editFlag == 0 ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="updateA" remarkId="${cr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkId="${cr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" id="saveCreateCustomerRemarkBtn" class="btn btn-primary">保存</button>
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
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
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
						<%--<tr>
							<td><a href="transaction/detail.html" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeTransactionModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
						<c:forEach items="${tranList}" var="t">
							<tr>
								<td><a href="workbench/transaction/toTranDetail.do?id=${t.id}" style="text-decoration: none;">${t.name}</a></td>
								<td>${t.money}</td>
								<td>${t.stage}</td>
								<td>90</td>
								<td>${t.expectedDate}</td>
								<td>${t.type}</td>
								<td><a href="javascript:void(0);" name="deleteTranA" tranId="${t.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/customer/toCreateTran.do" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactsListTB">
						<%--<tr>
							<td><a href="contacts/detail.html" style="text-decoration: none;">李四</a></td>
							<td>lisi@bjpowernode.com</td>
							<td>13543645364</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
						<c:forEach items="${contactsList}" var="c">
							<tr>
								<td><a href="contacts/detail.html" style="text-decoration: none;">${c.fullname}</a></td>
								<td>${c.email}</td>
								<td>${c.mphone}</td>
								<td><a href="javascript:void(0);" name="deleteContactsA" contactsId="${c.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#createContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>