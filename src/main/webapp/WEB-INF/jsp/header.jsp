<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>마스크거기 - thereright</title>
	<meta name="viewport" content="width=device-width,height=device-height,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<meta property="og:title" content="마스크 거기">
	<meta property="og:description" content="마스크 관련 공공데이터를 이용한 판매처 및 재고현황을 제공하는 서비스입니다.">
	<meta property="og:url" content="https://www.thereright.co.kr">
	<meta property="og:type" content="website">
	<meta property="og:image" content="">
	<meta name="description" content="공공데이터를 활용한 마스크 판매처 및 재고 현황을 제공하는 서비스입니다." />
	<meta name="naver-site-verification" content="35d9bc3262f8f9b45b902fb875586a9a965099dd"/>
	<meta name="google-site-verification" content="0EJP9jEvzKPlfbRC0y57xWXrAIVIWJ69yR9m1MyUXe8" />
	<link rel="shortcut icon" href="/icons/favicon.ico" type="image/x-icon">
	<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fe3820d4a415ead65c11b74b1392d151&libraries=services"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-151381503-2"></script>
	<script>
		window.dataLayer = window.dataLayer || [];
		function gtag() {
			dataLayer.push(arguments);
		}
		gtag('js', new Date());
		gtag('config', 'UA-151381503-2');
	</script>
	
	<style>
		.wrap {
			position: absolute;
			left: 0;
			bottom: 40px;
			width: 200px;
			height: 190px;
			margin-left: -97.5px;
			text-align: left;
			overflow: hidden;
			font-size: 12px;
			font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
			line-height: 1.5;
			z-index: 9999;
		}
		
		.wrap * {
			padding: 0;
			margin: 0;
		}
		
		.wrap .info {
			width: 100%;
			height: 180px;
			border-radius: 5px;
			border-bottom: 2px solid #ccc;
			border-right: 1px solid #ccc;
			overflow: hidden;
			background: #fff;
		}
		
		.wrap .info:nth-child(1) {
			border: 0;
			box-shadow: 0px 1px 2px #888;
		}
		
		.info .title {
			padding: 5px 0 0 10px;
			height: 40px;
			background: #eee;
			border-bottom: 1px solid #ddd;
			font-size: 17px;
			font-weight: bold;
			display: flex;
			align-items: center;
		}
		
		.info .body {
			position: relative;
			width: 100%;
			padding: 10px;
		}
		
		.info .desc {
			position: relative;
			margin: 13px 0 0 90px;
			height: 75px;
		}
		
		.desc .jibun {
			font-size: 11px;
			color: #888;
			margin-top: -2px;
		}
		
		.info .addr {
			white-space: normal;
		}
		
		.info .img {
			position: absolute;
			top: 6px;
			left: 5px;
			width: 73px;
			height: 71px;
			border: 1px solid #ddd;
			color: #888;
			overflow: hidden;
		}
		
		.info:after {
			content: '';
			position: absolute;
			margin-left: -12px;
			left: 50%;
			bottom: 0;
			width: 22px;
			height: 12px;
		}
		
		.info .link {
			color: #5085BB;
		}
	</style>
	
	<style>
		body {
			overflow: hidden;
		}
		
		#map {
			width: 100%;
			height: 100vh;
		}
		
		.wrapper {
			overflow-y: scroll;
		}
		.navigation {
			width: 100%;
			padding-top: 10px;
			padding-bottom: 10px;
			background-color: rgb(0,0,0, 0.7);
			position: absolute;
			z-index: 1000;
			padding-left: 5px;
			padding-right: 5px;
		}
		
		.footer {
			position: absolute;
			width: 100%;
			padding-top: 5px;
			padding-bottom: 5px;
			bottom: 0;
			background-color: rgb(0,0,0, 0.7);
			z-index: 1000;
		}
		
		.overlay-btn {
			position: absolute;
			z-index: 1000;
			border-radius: 100%;
			width: 50px;
			height: 50px;
			display: flex;s
			align-items: center;
			text-align: center;
		}
		
		#quick_panto {
			position: absolute;
			z-index: 1000;
			border-radius: 10px;
			width: 150px;
			display: flex;
			align-items: center;
			text-align: center;
			top: 65px;
			left: 20px;
			background-repeat: no-repeat;
			background: black; 
		}
		
		.sidebar_open {
			display: flex;
			align-items: center;
			border: 1px solid #505050;
			border-radius: 5px;
			background: transparent;
		}
		
		.sidebar {
			width: 230px;
			height: 100vh;
			position: absolute;
			z-index: 9999;
			left: -300px;
			box-shadow: 0 0 25px 5px;
		}
		
		.sidebar-group {
			list-style: none;
			padding: 0;
		}
		
		.sidebar-item {
			cursor: pointer;
		}
		
		.sidebar-item:hover {
			background-color: #505050;
		}
		
		.sidebar-link {
			padding: 10px;
			font-size: 18px;
			font-weight: bold;
			color: white;
			display: flex;
			align-items: center;
		}
		.sidebar-link:hover {
			text-decoration: none;
			color: white;
		}
		
		.item-dep1,
		.item-dep2 {
		}
		
		.sidebar_close {
			display: flex;
			align-items: center;
			border: 1px solid #505050;
			border-radius: 5px;
			background: transparent;
		}
	</style>
</head>
<body>
	<header class="navigation d-flex justify-content-between align-items-center flex-wrap">
		<button type="button" id="sidebar_open" class="sidebar_open">
			<i class="material-icons text-white" style="font-size: 30px;">menu</i>
		</button>
		
		<label class="font-weight-bold text-white m-0 col-8 col-sm-6 text-center" style="font-size: 20px;">
			<c:set var="path" value="${requestScope['javax.servlet.forward.servlet_path']}" /> 

			<c:choose>
            	<c:when test="${path.equals('/')}">
            		마스크 탐색
            	</c:when>
            	<c:when test="${path.contains('/corona/')}">
					코로나19 현황
            	</c:when>
           	</c:choose>
		</label>
		
		<button type="button" class="invisible" disabled>
			<i class="material-icons">menu</i>
		</button>
	</header>
	
	<nav class="sidebar bg-dark" id="sidebar">
		<div class="text-right d-flex justify-content-end align-items-center px-2" style="border: 1px solid #464646; height: 54.8611px;">
			<button type="button" id="sidebar_close" class="sidebar_close">
				<i class="material-icons text-white" style="font-size: 30px;">arrow_back</i>
			</button>
		</div>
		<ul class="sidebar-group">
			<li class="sidebar-item item-dep1">
				<a class="sidebar-link" href="/">
					<i class="material-icons pr-3">search</i>
					마스크 탐색
				</a>
			</li>
			<li class="sidebar-item item-dep2">
				<a class="sidebar-link" href="/corona/">
					<i class="material-icons pr-3">bar_chart</i>
					코로나19 현황
				</a>
			</li>
		</ul>
	</nav>
	
	<div id="wrapper" class="wrapper">