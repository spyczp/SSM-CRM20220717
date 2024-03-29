<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<meta charset="UTF-8">
<!--  BOOTSTRAP -->
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<!--  PAGINATION plugin -->
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

<!--  JQUERY -->
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<!--  BOOTSTRAP -->
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

<script type="text/javascript">

	$(function(){
        //当市场活动页面加载完毕后，查询所有数据的第一页以及所有数据的总条数，默认每页显示10条数据。
        showActivityList(1, 10);

		//给创建按钮添加单击事件
		$("#createActivityBtn").click(function () {
			//打开创建市场活动的模态窗口
			$("#createActivityModal").modal("show");
		});

        //给创建市场活动模态窗口中的日期输入框添加日历插件
        $(".mydate").datetimepicker({
            language: "en",
            format: "yyyy-mm-dd",
            autoclose: true,
            minView: "month",
            initialDate: new Date(),
            todayBtn: true,
            clearBtn: true
        });


		//给保存按钮添加事件：保存市场活动
		$("#saveBtn").click(function () {
			//收集参数
			var owner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val());
			var startDate = $("#create-startDate").val();
			var endDate = $("#create-endDate").val();
			var cost = $.trim($("#create-cost").val());
			var description = $.trim($("#create-description").val())
			//验证参数合法性
			if(owner == ""){
				alert("所有者不能为空");
				return;
			}
			if(name == ""){
				alert("名称不能为空");
				return;
			}
			if(startDate != "" && endDate != ""){
				if(startDate > endDate){
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			//定义正则表达式：匹配非负整数
			var regExp = /^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能为非负整数");
				return;
			}

			$.ajax({
				url: "workbench/activity/createActivity.do",
				data:{
					"owner": owner,
					"name": name,
					"startDate": startDate,
					"endDate": endDate,
					"cost": cost,
					"description": description
				},
				type: "post",
				dataType: "json",
				success: function(response){
					if(response.code == "1"){
						//刷新市场活动列表
						showActivityList(1, $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
						//清空表单里刚才填的数据
						$("#createActivityForm")[0].reset();
						//保存成功，关闭模态窗口，
						$("#createActivityModal").modal("hide");
					}else{
						//添加失败，显示提示信息
						alert(response.message);
					}
				}
			});
		});

        //给“查询”按钮加单击事件
        $("#queryBtn").click(function(){
            //用户点击“查询”按钮后，把查询条件保存到隐藏标签中。
            //目的是在分页查询的时候，以保存到隐藏标签的查询条件为准。
            // 防止用户在条件框中误输入字符而没有点击查询按钮，即后面输入的字符并非是条件。
            var name = $.trim($("#query-name").val());
            var owner = $.trim($("#query-owner").val());
            var startDate = $.trim($("#query-startDate").val());
            var endDate = $.trim($("#query-endDate").val());
            $("#hide-name").val(name);
            $("#hide-owner").val(owner);
            $("#hide-startDate").val(startDate);
            $("#hide-endDate").val(endDate);

            //展示符合查询条件的市场活动列表
            showActivityList(1, $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
        });

		//给“全选”按钮添加单击事件
		$("#checkAll").click(function () {
			/*if(this.checked){
				//如果“全选”按钮选中，则列表中所有checkbox都选中。
				$("#activityListTB input[type='checkbox']").prop("checked", true);
			}else{
				//否则，都不选中。
				$("#activityListTB input[type='checkbox']").prop("checked", false);
			}*/
			$("#activityListTB input[type='checkbox']").prop("checked", this.checked);
		});

        $("#activityListTB").on("click", "input[type='checkbox']", function () {
           //如果列表中的所有checkbox都选中，则全选按钮选中。
            if($("#activityListTB input[type='checkbox']").size() == $("#activityListTB input[type='checkbox']:checked").size()){
                $("#checkAll").prop("checked", true);
            }else{
                //只要列表中有一个checkbox没有选中，则全选按钮不选中。
                $("#checkAll").prop("checked", false);
            }
        });

		//给删除市场活动按钮添加点击事件
		$("#deleteActivityBtn").click(function () {
			//首先拿到选中的checkbox
			var checkedIds = $("#activityListTB input[type='checkbox']:checked");
			//如果选中的checkbox个数为0，提示
			if(checkedIds.size() == 0){
				alert("请选择要删除的市场活动");
				return;
			}

			if(window.confirm("确定删除吗？")){
				//遍历dom对象，拿到所有id，拼接请求参数
				var ids = "";
				$.each(checkedIds, function () {
					ids += "id=" + this.value + "&";
				});
				//要去掉最后多余的符号：&
				ids = ids.substr(0, ids.length - 1);
				//向后台发起异步请求
				$.ajax({
					url: "workbench/activity/deleteActivityByIds.do",
					data: ids,
					type: "get",
					dataType: "json",
					success: function (response) {
						if(response.code == "1"){
							//删除成功，刷新市场活动列表
							showActivityList(1, $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert(response.message);
						}
					}
				});
			}
		});

		/*给修改市场活动按钮添加单击事件*/
		$("#editActivityBtn").click(function () {
			var checkedId = $("#activityListTB input[type='checkbox']:checked");
			if(checkedId.size() != 1){
				alert("请选中一个市场活动来进行修改");
				return;
			}
			var id = checkedId.val();
			//向后台发起请求：根据市场活动的id查找市场活动信息
			$.ajax({
				url: "workbench/activity/queryActivityById.do",
				data: {
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					//往“修改市场活动的模态窗口"的表格中填写市场活动的原信息。
					$("#edit-activityId").val(response.id);
					$("#edit-marketActivityOwner").val(response.owner);
					$("#edit-marketActivityName").val(response.name);
					$("#edit-startDate").val(response.startDate);
					$("#edit-endDate").val(response.endDate);
					$("#edit-cost").val(response.cost);
					$("#edit-description").val(response.description);

					//打开“修改市场活动的模态窗口”
					$("#editActivityModal").modal("show");
				}
			});
		});

		//给”修改市场活动的模态窗口“中的”更新“按钮添加单击事件:提交修改后的市场活动数据
		$("#updateActivityBtn").click(function () {
			var id = $("#edit-activityId").val();
			var owner = $("#edit-marketActivityOwner").val();
			var name = $.trim($("#edit-marketActivityName").val());
			var startDate = $("#edit-startDate").val();
			var endDate = $("#edit-endDate").val();
			var cost = $.trim($("#edit-cost").val());
			var description = $.trim($("#edit-description").val());

			//验证参数是否合法
			if(name == ""){
				alert("名称不能为空");
				return;
			}
			if(startDate != "" && endDate != ""){
				if(startDate > endDate){
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			//定义正则表达式：匹配非负整数
			var regExp = /^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能为非负整数");
				return;
			}

			//向后头发起请求，修改市场活动的数据。
			$.ajax({
				url: "workbench/activity/modifyActivityById.do",
				data: {
					"id": id,
					"owner": owner,
					"name": name,
					"startDate": startDate,
					"endDate": endDate,
					"cost": cost,
					"description": description
				},
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//代表修改成功，刷新市场活动列表，且停留在当前页，每页显示条数不变。
						showActivityList($("#paginationD").bs_pagination('getOption', 'currentPage'), $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
						//关闭模态窗口。
						$("#editActivityModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
			});
		});

		//给“批量下载”市场活动信息按钮添加单击事件
		$("#exportActivityAllBtn").click(function () {
			//下载文件必须用同步请求
			//批量下载市场活动列表excel
			window.location.href = "workbench/activity/exportAllActivities.do";
		});

		//给“选择导出”添加点击事件，导出选择的市场活动信息
		$("#exportActivityXzBtn").click(function () {
			//先判断用户是否勾选了要导出的市场活动
			var checkedId = $("#activityListTB input[type='checkbox']:checked");
			if(checkedId.size() == 0){
				alert("请选择需要导出的市场活动");
				return;
			}
			var params = "";
			$.each(checkedId, function(){
				params += "id=" + this.value + "&";
			});
			params = params.substr(0, params.length - 1);
			window.location.href = "workbench/activity/exportActivityByIds.do?" + params;
		});


        //给“导入”按钮添加单击事件：导入市场活动
		$("#importActivityBtn").click(function () {
			//获取文件名，对文件名的后缀进行判断
			var fileName = $("#activityFile").val();
			//截取后缀并转为小写字母。
			var suffix = fileName.substr(fileName.lastIndexOf(".") + 1).toLocaleLowerCase();
			if(suffix != "xls"){
				alert("只支持后缀为xls的excel文件");
				return;
			}
            //获取dom对象保存的文件
            var activityFile = $("#activityFile")[0].files[0];
            //获取文件的大小,并判断文件大小是否超过5MB
            if(activityFile.size > 5 * 1024 * 1024){
                alert("文件大小不超过5MB");
                return;
            }
			var formData = new FormData();
			formData.append("activityFile", activityFile);
            //向后端发起请求
            $.ajax({
                url: "workbench/activity/importActivity.do",
				data:formData,
				processData: false, // 设置ajax向后端提交参数之前，是否把参数统一转换成字符串。true为是，false为否。默认是true。
				contentType: false, // 设置ajax向后端提交参数之前，是否把所有的参数统一按urlencoded编码：true为是，false为否。默认为true。
				type: "post",
				dataType: "json",
				success: function (response) {
					if(response.code == "1"){
						//代表上传成功，提示成功条数，刷新市场活动列表，关闭模态窗口
						alert("共成功导入" + response.retData + "条数据");
						showActivityList(1, $("#paginationD").bs_pagination('getOption', 'rowsPerPage'));
						$("#importActivityModal").modal("hide");
					}else{
						alert(response.message);
					}
				}
            });
		});
	});

	//展示市场活动列表
	function showActivityList(pageNo, pageSize) {
		//到后台拿市场活动列表
		//收集参数
		var name = $.trim($("#hide-name").val());
		var owner = $.trim($("#hide-owner").val());
		var startDate = $("#hide-startDate").val();
		var endDate = $("#hide-endDate").val();

		//向后台请求数据
		$.ajax({
			url: "workbench/activity/queryActivityByConditionForPage.do",
			data: {
				"name": name,
				"owner": owner,
				"startDate": startDate,
				"endDate": endDate,
				"pageNo": pageNo,
				"pageSize": pageSize
			},
			type: "post",
			dataType: "json",
			success: function (response) {
				//显示总条数
				//$("#totalRowsB").html(response.totalRows);
				//显示市场活动列表
				//遍历activityList,拼接标签
				var html = "";
				$.each(response.activityList, function (i, v) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" value="' + v.id + '"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/queryActivityForDetailById.do?id='+v.id+'\';">' + v.name + '</a></td>';
					html += '<td>' + v.owner + '</td>';
					html += '<td>' + v.startDate + '</td>';
					html += '<td>' + v.endDate + '</td>';
					html += '</tr>';
				});
				$("#activityListTB").html(html);

                //取消“全选”按钮（因为翻页会出现之前打勾的全选按钮没有取消的情况）
                //因为是点击翻页按钮，没有点击列表的checkbox按钮，所以没有触发上面取消全选按钮的代码
                $("#checkAll").prop("checked", false);


				//计算总页数
				var totalPages = response.totalRows % pageSize == 0 ? response.totalRows / pageSize : parseInt(response.totalRows / pageSize) + 1;

				//调用分页插件工具函数
				$("#paginationD").bs_pagination({
					totalPages: totalPages,
					currentPage: pageNo,
					rowsPerPage: pageSize,
					totalRows: response.totalRows,
					visiblePageLinks: 5,
					onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
						showActivityList(pageObj.currentPage, pageObj.rowsPerPage);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>
    <input type="hidden" id="hide-name">
    <input type="hidden" id="hide-owner">
    <input type="hidden" id="hide-startDate">
    <input type="hidden" id="hide-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="createActivityForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
									  <option></option>
									<c:forEach items="${requestScope.users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-activityId">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								  <c:forEach items="${requestScope.users}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startDate" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endDate" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control mydate" type="text" id="query-startDate" readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control mydate" type="text" id="query-endDate" readonly/>
				    </div>
				  </div>
				  
				  <button type="button" id="queryBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityListTB">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>

			<%--分页插件容器--%>
			<div id="paginationD"></div>
			
			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>
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