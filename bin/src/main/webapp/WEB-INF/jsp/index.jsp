<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<jsp:include page="header.jsp" />
	
	<style>
		#map {
			width: 100%;
			height: 100vh;
		}
		
		.navigation {
			width: 100%;
			padding-top: 10px;
			padding-bottom: 10px;
			background-color: rgb(0,0,0, 0.7);
			position: absolute;
			z-index: 1000;
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
	</style>
	<header class="navigation d-flex justify-content-center align-items-center flex-wrap">
		<label class="font-weight-bold text-white m-0 col-12 col-sm-2 text-center" style="font-size: 20px;">
			지역선택
		</label>
		<div class="col-12 col-sm-8 col-lg-4 d-flex" style="opacity: 1">
			<select id="region" class="form-control"></select>
			<select id="sigungu" class="form-control mx-2"></select>
<!-- 			<select id="umd" class="form-control"></select> -->
		</div>
	</header>
	<div id="map"></div>
	
	<footer class="footer d-flex justify-content-between">
		<label class="font-weight-bold text-white m-0 px-2 text-center" style="font-size: 15px;">
			마스크거기 v0.1
		</label>
		<label class="font-weight-bold text-white m-0 px-2 text-center" style="font-size: 15px;">
			개발자 메일 : chaehunbn@gmail.com
		</label>
	</footer>
	
	<div class="modal" id="announceModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title font-weight-bold">
						알림
					</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" style="font-size: 16px;">
					<div>
						<strong>
							1. 검색 체계 변경예정
						</strong>
					</div>
					<div class="ml-2 mb-2">
						- 콤보박스 -> 검색체계
					</div>
					<div class="mb-2">
						<strong>
							2. 지도 마커 클릭 시 표출되는 툴팁 UI 변경 예정
						</strong>
					</div>
					<div>
						<strong>
							3. 지도 고도화 예정
						</strong>
					</div>
					<div class="ml-2 mb-2">
						- 중심, 레벨 등 접근성 고도화
					</div>
					
					<p class="m-0 mt-4 text-right">
						배포 버전 : 0.1<br>
						데이터 출처 : 공공데이터 포털
					</p>
				</div>
			</div>
		</div>
	</div>
	<script>
		let currentMarkers = [];

		const fetchCode = function(type, code) {
			let url = '/code/list?type=' + type;
			if (code != null) {
				url += '&code=' + code;
			}
			
			$.ajax({
				url: url,
				type: 'GET',
				dataType: 'json',
				success: function(result) {
					console.log(result);
					
					const list = result.list;
					
					if (result.type == 0) {
						$('#region').html('');
						
						let str = '';
						for (let i in list) {
							const item = list[i];
							
							if (i == 0) {
								str += '<option value="' + item.name + '" data-code="' + item.region + '" selected>' + item.name + '</option>';
							} else {
								str += '<option value="' + item.name + '" data-code="' + item.region + '">' + item.name + '</option>';
							}
						}
						$('#region').append(str);
						
					} else if (result.type == 1) {
						$('#sigungu').html('');
						
						let str = '';
						for (let i in list) {
							const item = list[i];
							str += '<option value="' + item.name + '" data-code="' + item.sigungu + '">' + item.name + '</option>';
						}
						
						$('#sigungu').append(str);
						
					} else if (result.type == 2) {
// 						$('#umd').html('');
						
// 						let str = '';
// 						for (let i in list) {
// 							const item = list[i];
// 							str += '<option value="' + item.name + '" data-code="' + item.umd + '">' + item.name + '</option>';
// 						}
// 						$('#umd').append(str);
					}
				}
			});
		}
		const fetch = function(address) {
			$.ajax({
				url: '/search/' + address,
				type: 'GET',
				dataType: 'json',
				success: function(result) {
					const stores = result.stores;

					if (result.count <= 0) {
						return;
					}
					
					setMarkers(null);
					currentMarkers = [];
					
					let latMax = 0;
					let latMin = 1000;
					let lngMax = 0;
					let lngMin = 1000;
					
					for (var i = 0; i < stores.length; i ++) {
						const positions = stores[i];
						
						const lat = positions.lat;
						const lng = positions.lng;
						
						if (lat > latMax) {
							latMax = lat;
						}
						if (lat < latMin) {
							latMin = lat;
						}
						if (lng > lngMax) {
							lngMax = lng;
						}
						if (lng < lngMin) {
							lngMin = lng;
						}
					    // 마커 이미지의 이미지 크기 입니다
					    var imageSize = new kakao.maps.Size(24, 35); 
					    
					    // 마커 이미지를 생성합니다    
					    let imageSrc = '';
						
					    if (positions.remain_stat == 'plenty') {
					    	imageSrc = plentySrc;
					    } else if (positions.remain_stat == 'some') {
					    	imageSrc = someSrc;
					    } else if (positions.remain_stat == 'few') {
					    	imageSrc = fewSrc;
					    } else if (positions.remain_stat == 'empty') {
					    	imageSrc = emptySrc;
					    }
					    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
					    
					    // 마커를 생성합니다
					    var marker = new kakao.maps.Marker({
					        map: map, // 마커를 표시할 지도
					        position: new kakao.maps.LatLng(positions.lat, positions.lng), // 마커를 표시할 위치
					        title : positions.name, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
					        image : markerImage // 마커 이미지 
					    });

					    currentMarkers.push(marker);
					    
					    // 마커에 표시할 인포윈도우를 생성합니다 
					    var infowindow = new kakao.maps.InfoWindow({
					        content: positions.name // 인포윈도우에 표시할 내용
					    });

					    kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
					    kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
					    kakao.maps.event.addListener(marker, 'click', makeClickListener(map, marker, infowindow));
					}
					
					const to_lat = latMin + ((latMax - latMin) / 2);
					const to_lng = lngMin + ((lngMax - lngMin) / 2);

					panTo(to_lat, to_lng);
				}
			});
		}
		
		// 배열에 추가된 마커들을 지도에 표시하거나 삭제하는 함수입니다
		function setMarkers(map) {
		    for (var i = 0; i < currentMarkers.length; i++) {
		    	currentMarkers[i].setMap(map);
		    }            
		}
		
		const changeCallback = function(e) {
			const region = $('#region').val();
			const sigungu = $('#sigungu').val();
// 			const umd = $('#umd').val();
			
			let address = '';
			
			if (region != null) {
				address += region + ' ';
			}
			if (sigungu != null) {
				address += sigungu + ' ';
			}
// 			if (umd != null) {
// 				address += umd;
// 			}
			
			fetch(address);
		}
		
		$(document).ready(function() {
			$('#announceModal').modal('show')
			$('#map').height(window.innerHeight + 'px');
			
			fetch('서울특별시 중구');
			fetchCode(-1);
			fetchCode(1, 11);

			$('#region').change(function(e) {
				const selected = e.target.selectedOptions[0];
				fetchCode(1, selected.dataset.code);
			});

			$('#sigungu').change(function(e) {
				const selected = e.target.selectedOptions[0];
				fetchCode(2, selected.dataset.code);
				console.log(selected)
			});

// 			$('#umd').change(function(e) {
// 				const selected = e.target.selectedOptions[0];
// 				fetchCode(3, selected.dataset.code);
// 				console.log(selected)
// 			});
			
			$('#region').change(changeCallback);
			$('#sigungu').change(changeCallback);
// 			$('#umd').change(changeCallback);
		});
		
		var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
		var options = { //지도를 생성할 때 필요한 기본 옵션
			center: new kakao.maps.LatLng(34.4906353, 126.9082173), //지도의 중심좌표.
			level: 6 //지도의 레벨(확대, 축소 정도)
		};
		
		var map = new kakao.maps.Map(container, options); // 지도를 생성합니다
		
		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(map, marker, infowindow) {
		    return function() {
		        infowindow.open(map, marker);
		    };
		}

		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function makeOutListener(infowindow) {
		    return function() {
		        infowindow.close();
		    };
		}
		
		function makeClickListener(map, marker, infowindow) {
		    return function() {
		        infowindow.open(map, marker);
		    };
	    }
		
		function panTo(lat, lng) {
		    // 이동할 위도 경도 위치를 생성합니다 
		    var moveLatLon = new kakao.maps.LatLng(lat, lng);
		    // 지도 중심을 부드럽게 이동시킵니다
		    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
		    map.panTo(moveLatLon);            
		}    
		
		const plentySrc = "/icons/plenty.png";
		const someSrc = "/icons/some.png";
		const fewSrc = "/icons/few.png";
		const emptySrc = "/icons/empty.png";
	</script>
</body>
</html>