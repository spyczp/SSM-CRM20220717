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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<!--  PAGINATION(分页插件) plugin -->
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>


<script type="text/javascript">

	$(function(){

		//展示线索列表
		showClueList(1, 2);

		//引入日期插件
		$(".mydate").datetimepicker({
			language: "en",
			format: "yyyy-mm-dd",
			autoclose: true,
			minView: "month",
			initialDate: new Date(),
			todayBtn: true,
			clearBtn: true
		});

		//给保存按钮添加单击事件
		$("#saveClueBtn").click(function () {
			//收集数据
			//var owner = $("#create-owner>option:selected").val();
			var owner = $("#create-owner").val();
			var company = $.trim($("#create-company").val());
			var appellation = $("#create-appellation").val();
			var fullname = $.trim($("#create-fullname").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val());
			var website = $.trim($("#create-website").val());
			var mphone = $.trim($("#create-mphone").val());
			var state = $("#create-state").val();
			var source =$("#create-source").val();
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());

			//验证数据
			if(company == ""){
				alert("公司信息不能为空");
				return;
			}
			if(fullname == ""){
				alert("姓名不能为空");
				return;
			}
			var regExpEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(!regExpEmail.test(email)){
				alert("邮箱格式不正确，请查看");
				return;
			}
			var regExpPhone = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if(!regExpPhone.test(phone)){
				alert("座机号码格式不符合要求");
				return;
			}
			var regExpWebsite = /[a-zA-z]+:\/\/[^\s]*/;
			if(!regExpWebsite.test(website)){
				alert("网站格式不符合要求");
				return;
			}
			var regExpMphone = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(!regExpMphone.test(mphone)){
				alert("手机号码格式不符合要求");
				return;
			}

			//向后台发起请求
			$.ajax({
				url: "workbench/clue/saveCreateClue.do",
				data: {
					"owner": owner,
					"company": company,
					"appellation": appellation,
					"fullname": fullname,
					"job": job,
					"email": email,
					"phone": phone,
					"website": website,
					"mphone": mphone,
					"state": state,
					"source": source,
					"description": description,
					"contactSummary": contactSummary,
					"nextContactTime": nextContactTime,
					"address": address
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//成功，则刷新线索列表，关闭模态窗口，清空模态窗口的表单
						showClueList(1, $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
						$("#createClueModal").modal("hide");
						$("#createClueForm")[0].reset();
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给查询按钮添加单击事件
		$("#searchClueBtn").click(function () {
			//收集参数
			var fullname = $.trim($("#search-fullname").val());
			var owner = $.trim($("#search-owner").val());
			var company = $.trim($("#search-company").val());
			var mphone = $.trim($("#search-mphone").val());
			var phone = $.trim($("#search-phone").val());
			var state = $("#search-state").val();
			var source = $("#search-source").val();

			//把上面的参数保存到隐藏域中
			$("#hidden-fullname").val(fullname);
			$("#hidden-owner").val(owner);
			$("#hidden-company").val(company);
			$("#hidden-mphone").val(mphone);
			$("#hidden-phone").val(phone);
			$("#hidden-state").val(state);
			$("#hidden-source").val(source);

			//向后台发起请求
			showClueList(1, $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
		});

		//全选复选框功能
		$("#checkAll").click(function () {
			//当全选复选框打勾后，所有线索条目复选框打勾。当全选复选框不打勾后，所有线索条目复选框不打勾。
			$("#clueListTB input[type='checkbox']").prop("checked", this.checked);
		});

		$("#clueListTB").on("click", "input[type='checkbox']", function () {
			//当所有线索条目复选框打勾后，全选复选框打勾。只要有一个线索条目复选框没有打勾，则全选复选框不打勾。
			if($("#clueListTB input[type='checkbox']").size() == $("#clueListTB input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked", true);
			}else{
				$("#checkAll").prop("checked", false);
			}
		});

		//给修改按钮添加单击事件
		$("#editClueBtn").click(function () {
			//判断用户是否选中了一个线索
			if($("#clueListTB input[type='checkbox']:checked").size() != 1){
				alert("请选中一个线索进行修改操作，不能多选。");
				return;
			}
			var id = $("#clueListTB input[type='checkbox']:checked").val();

			//向后端发起请求，获取选中的线索的信息
			$.ajax({
				url: "workbench/clue/queryClueById.do",
				data: {
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					//给修改线索的模态窗口填值
					$("#edit-id").val(response.id);
					$("#edit-owner").val(response.owner);
					$("#edit-company").val(response.company);
					$("#edit-appellation").val(response.appellation);
					$("#edit-fullname").val(response.fullname);
					$("#edit-job").val(response.job);
					$("#edit-email").val(response.email);
					$("#edit-phone").val(response.phone);
					$("#edit-website").val(response.website);
					$("#edit-mphone").val(response.mphone);
					$("#edit-state").val(response.state);
					$("#edit-source").val(response.source);
					$("#edit-description").val(response.description);
					$("#edit-contactSummary").val(response.contactSummary);
					$("#edit-nextContactTime").val(response.nextContactTime);
					$("#edit-address").val(response.address);
					//打开修改线索的模态窗口
					$("#editClueModal").modal("show");
				}
			});
		});

		//给更新按钮添加单击事件
		$("#saveEditClueBtn").click(function () {
			//收集参数
			var id = $("#edit-id").val();
			var owner = $("#edit-owner").val();
			var company = $.trim($("#edit-company").val());
			var appellation = $("#edit-appellation").val();
			var fullname = $.trim($("#edit-fullname").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($("#edit-website").val());
			var mphone = $.trim($("#edit-mphone").val());
			var state = $("#edit-state").val();
			var source = $("#edit-source").val();
			var description = $.trim($("#edit-description").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $.trim($("#edit-address").val());

			//验证参数合法性
			if(company == ""){
				alert("公司信息不能为空");
				return;
			}
			if(fullname == ""){
				alert("姓名不能为空");
				return;
			}
			var regExpEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(!regExpEmail.test(email)){
				alert("邮箱格式不正确，请重新输入")
				return;
			}
			var regExpPhone = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if(!regExpPhone.test(phone)){
				alert("座机号码格式不符合要求");
				return;
			}
			var regExpWebsite = /[a-zA-z]+:\/\/[^\s]*/;
			if(!regExpWebsite.test(website)){
				alert("网站格式不符合要求");
				return;
			}
			var regExpMphone = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(!regExpMphone.test(mphone)){
				alert("手机号码格式不符合要求");
				return;
			}

			//向后端发起请求
			$.ajax({
				url: "workbench/clue/editClue.do",
				data: {
					"id": id,
					"owner": owner,
					"company": company,
					"appellation": appellation,
					"fullname": fullname,
					"job": job,
					"email": email,
					"phone": phone,
					"website": website,
					"mphone": mphone,
					"state": state,
					"source": source,
					"description": description,
					"contactSummary": contactSummary,
					"nextContactTime": nextContactTime,
					"address": address
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//更新成功，刷新线索列表，关闭模态窗口
						showClueList($("#paginationD").bs_pagination('getOption', 'currentPage'), $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
						$("#editClueModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给删除按钮添加单击事件
		$("#deleteClueBtn").click(function () {
			var checkedCB = $("#clueListTB input[type='checkbox']:checked");
			if(checkedCB.size() == 0){
				alert("请在要删除的线索前面打勾");
				return;
			}
			//询问用户是否删除
			if(confirm("是否删除？")){
				//拼接请求参数字符串
				var params = "";

				$.each(checkedCB, function () {
					params += "id=" + this.value + "&";
				});

				params = params.substr(0, params.length - 1);

				//向后端发起请求
				$.ajax({
					url: "workbench/clue/deleteClueByIds.do",
					data: params,
					type: "get",
					dataType: "json",
					success: function (response) {
						if(response.code == "1"){
							//删除成功，刷新线索列表
							showClueList(1, $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert(response.message);
						}
					}
				});
			}
		});
	});

	/*剩下：
	* 	跳转线索详情页
	* */

	//根据条件展示线索列表
	function showClueList(pageNo, pageSize) {
		//收集参数
		var fullname = $("#hidden-fullname").val();
		var owner = $("#hidden-owner").val();
		var company = $("#hidden-company").val();
		var mphone = $("#hidden-mphone").val();
		var phone = $("#hidden-phone").val();
		var state = $("#hidden-state").val();
		var source = $("#hidden-source").val();

		//向后端发起请求，获取线索列表
		$.ajax({
			url: "workbench/clue/queryClueByCondition.do",
			data: {
				"fullname": fullname,
				"owner": owner,
				"company": company,
				"mphone": mphone,
				"phone": phone,
				"state": state,
				"source": source,
				"pageNo": pageNo,
				"pageSize": pageSize
			},
			type: "post",
			dataType: "json",
			success: function(response){
				//字符串拼接，展示线索列表
				var html = "";

				$.each(response.clues, function (i, o) {
					html += '<tr>';
					html += '<td><input type="checkbox" value="'+o.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/queryClueByIdForDetail.do?id='+o.id+'\';">'+o.fullname+(o.appellation==null ? "": o.appellation)+'</a></td>';
					html += '<td>'+o.company+'</td>';
					html += '<td>'+o.phone+'</td>';
					html += '<td>'+o.mphone+'</td>';
					html += '<td>'+(o.source==null ? "" : o.source)+'</td>';
					html += '<td>'+o.owner+'</td>';
					html += '<td>'+(o.state==null ? "" : o.state)+'</td>';
					html += '</tr>';
				});

				$("#clueListTB").html(html);

				//总页数
				var totalPages = response.totalRows % pageSize == 0? response.totalRows / pageSize : parseInt(response.totalRows / pageSize) + 1;

				//调用分页插件工具函数
				$("#paginationD").bs_pagination({
					totalPages: totalPages,
					currentPage: pageNo,
					rowsPerPage: pageSize,
					totalRows: response.totalRows,
					visiblePageLinks: 5,
					onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
						showClueList(pageObj.currentPage, pageObj.rowsPerPage);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>
	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-company">
	<input type="hidden" id="hidden-mphone">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-state">
	<input type="hidden" id="hidden-source">

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createClueForm">
					
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
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
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
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <%--<option>试图联系</option>
								  <option>将来联系</option>
								  <option>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>--%>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
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
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
									<input type="text" class="mydate" id="create-nextContactTime" readonly>
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
					<button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
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
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <%--<option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
								  <%--<option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>--%>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
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
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
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
									<input type="text" class="mydate" id="edit-nextContactTime" readonly>
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
					<button type="button" class="btn btn-primary" id="saveEditClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="search-company">
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
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source">
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
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
					  	<%--<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>--%>
						  <c:forEach items="${clueStateList}" var="clueState">
							  <option value="${clueState.id}">${clueState.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="searchClueBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueListTB">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			<br>
			<br>
			<br>

			<div id="paginationD"></div>
			
			<%--<div style="height: 50px; position: relative;top: 60px;">
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