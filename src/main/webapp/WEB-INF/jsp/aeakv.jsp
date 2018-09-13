<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<sql:query var="rs" dataSource="jdbc/sqlserverAE">select name, age from [userAEAKV];</sql:query>
<html lang="en">
<head>

<!-- Access the bootstrap Css like this, 
		Spring boot will handle the resource mapping automcatically -->
<link rel="stylesheet" type="text/css"
	href="webjars/bootstrap/3.3.7/css/bootstrap.min.css" />

</head>
<body>

	<nav class="navbar navbar-inverse">
		<div class="container">
			<div class="navbar-header">
				<a class="navbar-brand" href="#">Spring Demo with MSSQL JDBC</a>
			</div>
			<div id="navbar" class="collapse navbar-collapse">
				<ul class="nav navbar-nav">
					<li><a href="index">Basic</a></li>
					<li><a href="ae">AE</a></li>
					<li><a href="aejks">AE with JKS</a></li>
					<li class="active"><a href="aeakv">AE with AKV</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<div class="container">
		<div class="starter-template">
			<h1>Spring Boot with MSSQL JDBC Driver</h1>
			<h2>Encryption: ${message}</h2>

			<h3>ResultSet for executed Query: select name, age from [userAEAKV] :</h3>

			<c:forEach var="row" items="${rs.rows}">
            ${row.name}
            (Age ${row.age})
            <br />
			</c:forEach>
		</div>
	</div>

	<script type="text/javascript"
		src="webjars/bootstrap/3.3.7/js/bootstrap.min.js"></script>

</body>
</html>
