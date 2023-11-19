<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>페이징</title>
</head>
<body>
	<%
	// 페이징 기본변수 3가지
	// 1. 한 화면(페이지)에 출력할 데이터 갯수
	// 2. 현재 페이지 번호
	// 3. 총 데이터 갯수

	int page_size = 10; // 기본 변수 1

	String pageNum = request.getParameter("page");
	if (pageNum == null) {
		pageNum = "1";
	}

	int currentPage = Integer.parseInt(pageNum);

	int count = 0;

	BoardDbBean dao = BoardDBBean.getInstance();
	count = dao.getCount();
	System.out.print("count: " + count);

	int stratRow = (currentPage - 1) * page_size + 1; // 등차수열
	int endRow = currentPage * page_size;

	List<BoardDataBean> list = null;
	if (count > 0) {
		list = dao.getList(stratRow, endRow);

		if (count == 0) {
	%>
	작성된 글이 없습니다.
	<%
	} else {
	%>
	<a href="writeForm.jsp">글작성</a> 글갯수 :
	<%=count%>
	<table border=1 width=700 align=center>
		<caption>게시판 목록</caption>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회수</th>
			<th>IP주소</th>
		</tr>
		<%
		int number = count - (currentPage - 1) * page_size;

		SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		for (int i = 0; i < list.size(); i++) {
			BoardDataBean board = list.get(i);
		%>
		<tr>
			<th><%=number--%></th>
			<td><a
				href="content.jsp?num=<%=board.getNum()%>&page=<%=currentPage%>"><%=board.getSubject()%></a></td>
			<td><%=board.getWriter()%></td>
			<td><%=sd.format(board.getReg_date())%></td>
			<td><%=board.getReadcount()%></td>
			<td><%=board.getIp()%></td>
		</tr>
		<%
		}
		%>
	</table>
	<%
	}
	%>

	<!-- 페이지 링크 -->
	<center>

		<%
		if (count > 0) {
			int pageCount = count / page_size + ((count % page_size == 0) ? 0 : 1);
			int startPage = ((currentPage - 1) / 10) * 10 + 1;
			int block = 10;
			int endPage = startPage + block - 1;

			if (endPage > pageCount) {
				endPage = pageCount;
			}
		%>
		<a href="list.jsp?page=1"> << </a>

		<%
		if (startPage > 10) {
		%><a href="list.jsp?page<%=startPage - 10%>">[이전]</a>
		<%
		}
		%>

		for(int i = startPage; i <= endPage; i++){ if(i == currenPage){ [<%=i%>]
		<%
		} else {
		%>
		<a href="list.jsp?page<%=startPage + 10%>">[다음]</a>
		<%
		}
		%>

		<a href="list.jsp?page=<%=pageCount%>" style="text-decoration: none">
			>> </a>
		<%
		}
		%>


	</center>
</body>
</html>