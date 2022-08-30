<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

<script type="text/javascript">

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
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//页面加载完毕之后，调用方法，展示客户列表。默认显示第一页，每页显示2条数据。
		showCustomerList(1, 2);

		//给 全选框 添加单击事件。
		//当全选框打勾后，所有单选框打勾
		$("#checkedAll").click(function(){
			$("#customerListTB input[type='checkbox']").prop("checked", this.checked);
		});
		//给 单选框 添加单击事件
		//当所有 单选框 打勾后，全选框也打勾。至少有一个单选框没有打勾，则全选框不打勾。
		$("#customerListTB").on("click", "input[type='checkbox']", function(){
			if($("#customerListTB input[type='checkbox']").size() == $("#customerListTB input[type='checkbox']:checked").size()){
				$("#checkedAll").prop("checked", true);
			}else{
				$("#checkedAll").prop("checked", false);
			}
		});

		//给创建客户的模态窗口中的 保存按钮 添加单击事件
		$("#saveCustomerBtn").click(function () {
			//收集参数
			var owner = $("#create-owner").val();
			var name = $.trim($("#create-name").val());
			var website = $.trim($("#create-website").val());
			var phone = $.trim($("#create-phone").val());
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());
			//验证参数
			if(name == ""){
				alert("名称不能为空");
				return;
			}
			var regxStr = /[a-zA-z]+:\/\/[^\s]*/;
			if(website != "" && !regxStr.test(website)){
				alert("网站格式不符合要求，请重新输入");
				return;
			}
			regxStr = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if(phone != "" && !regxStr.test(phone)){
				alert("公司座机不符合要求，请重新输入");
				return;
			}
			//向后端发起请求
			$.ajax({
				url: "workbench/customer/saveCreateCustomer.do",
				data: {
					"owner": owner,
					"name": name,
					"website": website,
					"phone": phone,
					"description": description,
					"contactSummary": contactSummary,
					"nextContactTime": nextContactTime,
					"address": address,
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//代表创建客户成功，刷新客户列表，，
						showCustomerList(1, $("#paginationDiv").bs_pagination('getOption', 'rowsPerPage'));
						//关闭模态窗口
						$("#createCustomerModal").modal("hide");
						//清空模态窗口的表单数据
						$("#createCustomerForm")[0].reset();
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给 修改 按钮添加单击事件
		$("#editCustomerBtn").click(function () {
			//拿到用户勾选的客户信息
			//判断用户是否只选了一个客户信息进行修改
			if($("#customerListTB input[type='checkbox']:checked").size() != 1){
				alert("必须且只能选择一个客户信息进行修改");
				return;
			}
			//收集参数
			var id = $("#customerListTB input[type='checkbox']:checked").val();
			//向后端发起请求
			$.ajax({
				url: "workbench/customer/queryCustomerById.do",
				data: {
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					//把数据填写到 修改客户的模态窗口 中的 表单 里。
					$("#edit-id").val(response.id);
					$("#edit-owner").val(response.owner);
					$("#edit-name").val(response.name);
					$("#edit-website").val(response.website);
					$("#edit-phone").val(response.phone);
					$("#edit-description").val(response.description);
					$("#edit-contactSummary").val(response.contactSummary);
					$("#edit-nextContactTime").val(response.nextContactTime);
					$("#edit-address").val(response.address);
					//打开 修改客户的模态窗口
					$("#editCustomerModal").modal("show");
				}
			});
		});

		//给 修改客户的模态窗口 中的 更新 按钮添加单击事件
		$("#saveEditBtn").click(function () {
			//收集参数
			var id = $("#edit-id").val();
			var owner = $("#edit-owner").val();
			var name = $.trim($("#edit-name").val());
			var website = $.trim($("#edit-website").val());
			var phone = $.trim($("#edit-phone").val());
			var description = $.trim($("#edit-description").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $("#edit-address").val();
			//验证参数合法性
			if(name == ""){
				alert("名称不能为空");
				return;
			}
			var regxStr = /[a-zA-z]+:\/\/[^\s]*/;
			if(website != "" && !regxStr.test(website)){
				alert("网站格式不符合要求，请重新输入");
				return;
			}
			regxStr = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if(phone != "" && !regxStr.test(phone)){
				alert("公司座机格式不符合要求，请重新输入");
				return;
			}
			//向后端发起请求
			$.ajax({
				url: "workbench/customer/saveEditCustomer.do",
				data: {
					"id": id,
					"owner": owner,
					"name": name,
					"website": website,
					"phone": phone,
					"description": description,
					"contactSummary": contactSummary,
					"nextContactTime": nextContactTime,
					"address": address
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//更新客户信息成功
						//刷新客户列表
						showCustomerList($("#paginationDiv").bs_pagination('getOption', 'currentPage'), $("#paginationDiv").bs_pagination('getOption', 'rowsPerPage'));
						//关闭模态窗口
						$("#editCustomerModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给 删除 按钮添加单击事件
		$("#deleteCustomerBtn").click(function () {
			//收集参数
			var checkedBox = $("#customerListTB input[type='checkbox']:checked");
			if(checkedBox.size() == 0){
				alert("请至少选择一条客户信息进行删除操作");
				return;
			}
			//询问用户是否确认删除
			if(confirm("请确认是否删除？数据将不可恢复")){
				//获取所有选择的客户id，进行请求参数拼接
				var param = "";
				$.each(checkedBox, function(){
					param += "id=" + this.value + "&";
				});
				param = param.substr(0, param.length -1);
				//向后端发起请求
				$.ajax({
					url: "workbench/customer/deleteCustomerByIds.do",
					data: param,
					type: "get",
					dataType: "json",
					success: function (response) {
						if(response.code == "1"){
							//删除成功
							//刷新客户列表
							showCustomerList(1, $("#paginationDiv").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert(response.message);
						}
					}
				});
			}
		});

		//给 查询 按钮添加单击事件
		$("#searchCustomerBtn").click(function () {
			//收集参数
			var name = $.trim($("#search-name").val());
			var owner = $.trim($("#search-owner").val());
			var phone = $.trim($("#search-phone").val());
			var website = $.trim($("#search-website").val());

			//把这些参数保存到隐藏标签中
			$("#hidden-name").val(name);
			$("#hidden-owner").val(owner);
			$("#hidden-phone").val(phone);
			$("#hidden-website").val(website);

			//调用 展示客户列表的方法
			showCustomerList(1, $("#paginationDiv").bs_pagination('getOption', 'rowsPerPage'));
		});
	});

	//展示客户列表的方法
	function showCustomerList(pageNo, pageSize){
		//取消勾选 全选框
		$("#checkedAll").prop("checked", false);
		//收集参数
		var name = $("#hidden-name").val();
		var owner = $("#hidden-owner").val();
		var phone = $("#hidden-phone").val();
		var website = $("#hidden-website").val();

		//向后端发起请求
		$.ajax({
			url: "workbench/customer/showCustomerList.do",
			data: {
				"name": name,
				"owner": owner,
				"phone": phone,
				"website": website,
				"pageNo": pageNo,
				"pageSize": pageSize,
			},
			type: "post",
			dataType: "json",
			success: function(response){
				//展示客户数据
				//字符串拼接，组装标签
				var html = "";
				$.each(response.customers, function (i, o) {
					html += '<tr>';
					html += '<td><input type="checkbox" value="'+o.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/showCustomerDetail.do?id='+o.id+'\';">'+o.name+'</a></td>';
					html += '<td>'+o.owner+'</td>';
					html += '<td>'+o.phone+'</td>';
					html += '<td>'+o.website+'</td>';
					html += '</tr>';
				});
				$("#customerListTB").html(html);

				//总页数
				var totalPages = response.totalRows % pageSize == 0 ? response.totalRows / pageSize : parseInt(response.totalRows / pageSize) + 1;

				//用容器调用分页插件函数
				$("#paginationDiv").bs_pagination({
					totalPages: totalPages,
					currentPage: pageNo,
					rowsPerPage: pageSize,
					totalRows: response.totalRows,
					visiblePageLinks: 5,
					onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
						showCustomerList(pageObj.currentPage, pageObj.rowsPerPage);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createCustomerForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
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
					<button type="button" class="btn btn-primary" id="saveCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id">

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
									  <c:forEach items="${users}" var="user">
										  <option value="${user.id}">${user.name}</option>
									  </c:forEach>
								</select>
							</div>
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="edit-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-website">

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="search-website">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchCustomerBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkedAll"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerListTB">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>
                            <td>zhangsan</td>
                            <td>010-84846003</td>
                            <td>http://www.bjpowernode.com</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			&nbsp;&nbsp;
			<div id="paginationDiv"></div>
			
			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>