<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<jsp:include page="header.jsp" />
	
	<style>
		#container {
			display: flex;
			justify-content: center;
			flex-wrap: wrap;
		}
		
		.table-title {
			font-size: 24px;
			text-align: center;
			font-weight: bold;
			margin-top: 20px;
			margin-bottom: 20px;
		}
	</style>
	<div id="container" class="container">
		<div style="width: 100%; height: 70px;"></div>
		<div class="col-12 col-lg-8 p-0">
			<div class="table-title">
				코로나19 지역별 통계
			</div>
			<div id="refresh_date" class="col-12 my-2 text-right"></div>
			<table class="table text-center col-12">
				<thead>
					<tr class="font-weight-bold">
						<th class="">지역</th>
						<th class="">확진자</th>
						<th class="">격리해제</th>
						<th class="">사망자</th>
						<th class="">발생률</th>
					</tr>
				</thead>
				<tbody id="table_body">
				
				</tbody>
			</table>
			<div class="col-12 my-2">
				발생률 : 인구 10만 명당 (지역별 인구 출처 : 행정안전부, 주민등록인구현황 (’20.1월 기준))
			</div>
			
			<div style="height: 120px"></div>
			
			<div class="table-title">
				코로나19 국가별 통계
			</div>
			<div id="nation_refresh_date" class="col-12 my-2 text-right"></div>
			<table class="table text-center col-12">
				<thead>
					<tr class="font-weight-bold">
						<th class="">국가</th>
						<th class="">확진자</th>
<!-- 						<th class="">격리해제</th> -->
						<th class="">사망자</th>
						<th class="">사망률</th>
					</tr>
				</thead>
				<tbody id="nation_table_body">
				
				</tbody>
			</table>
			
			<div style="height: 120px"></div>
		</div>
	</div>
	
	<jsp:include page="footer.jsp" />
	
	<script>
		$(document).ready(function() {
			$('#wrapper').height(window.innerHeight + 'px');

			$.ajax({
				url: '/corona/data',
				dataType: 'json',
				type: 'GET',
				success: function(result) {
					const corona = Object.entries(result.corona);
					const coronaDiff = Object.entries(result.coronaDiff);
					const release = Object.entries(result.coronaRelease);
					const died = Object.entries(result.coronaDied);
					const rate = Object.entries(result.coronaRate);
					const nation = result.coronaNation;
					
					let str = '';
					
					corona.forEach(function(item, index) {
						if (item[0] != 'type') {
							if (item[0] != 'no' && item[0] != 'createDate') {
								if (item[0] == 'total') {
									str += '<tr class="bg-dark text-white font-weight-bold">';
								} else {
									str += '<tr>';
								}
								str += '<td>';
								str += locationMap[item[0]];
								str += '</td>';
								str += '<td>';
								str += item[1].toLocaleString() + ' (<label class="text-danger m-0">+' + coronaDiff[index][1] + '</label>)';
								str += '</td>';
								str += '<td>';
								str += release[index][1].toLocaleString();
								str += '</td>';
								str += '<td>';
								str += died[index][1].toLocaleString();
								str += '</td>';
								str += '<td>';
								str += rate[index][1];
								str += '</td>';
								str += '</tr>';
							}
							if (item[0] == 'createDate') {
								const date = new Date(item[1]);
								$('#refresh_date').text('통계 업데이트 일시 : ' + date.getFullYear() + '년 ' + (date.getMonth() + 1) + '월 ' + date.getDate() + '일')
							}
								
						}
					});
					
					let nationStr = '';
					
					nation.forEach(function(item, index) {
						if (item.nation == '합계') {
							nationStr += '<tr class="bg-dark text-white font-weight-bold">';
						} else {
							nationStr += '<tr>';
						}
						nationStr += '<td>';
						nationStr += item.nation;
						nationStr += '</td>';
						nationStr += '<td>';
						nationStr += item.infection.toLocaleString(); + ' (<label class="text-danger m-0">+' + '' + '</label>)';
						nationStr += '</td>';
// 						nationStr += '<td>';
// 						nationStr += item.release;
// 						nationStr += '</td>';
						nationStr += '<td>';
						nationStr += item.die.toLocaleString();
						nationStr += '</td>';
						nationStr += '<td>';
						if (item.infection / item.die == 'Infinity') {
							nationStr += 0;
						} else {
							nationStr += (item.die / item.infection * 100).toFixed(2);
						}
						nationStr += '</td>';
						nationStr += '</tr>';
						if (index == 0) {
							const date = new Date(item.createDate);
							$('#nation_refresh_date').text('통계 업데이트 일시 : ' + date.getFullYear() + '년 ' + (date.getMonth() + 1) + '월 ' + date.getDate() + '일')
						}
					});
					
					$('#table_body').html(str)
					$('#nation_table_body').html(nationStr)
				}
			})
		});
		
		const locationMap = {
				"seoul": "서울",
				"busan": "부산",
				"daegu": "대구",
				"incheon": "인천",
				"gwangju": "광주",
				"daejeon": "대전",
				"ulsan": "울산",
				"sejong": "세종",
				"gyunggi": "경기도",
				"gangwon": "강원도",
				"chongbuk": "충청북도",
				"chongnam": "충청남도",
				"jeonbuk": "전라북도",
				"jeonnam": "전라남도",
				"gyungbuk": "경상북도",
				"gyungnam": "경상남도",
				"jeju": "제주",
				"total": "합계",
				"createDate": "갱신일자"
		}
	</script>