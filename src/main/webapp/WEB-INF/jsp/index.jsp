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
		
		.overlay-btn {
			position: absolute;
			z-index: 1000;
			border-radius: 100%;
			width: 50px;
			height: 50px;
			display: flex;
			align-items: center;
			text-align: center;
		}
	</style>
	<header class="navigation d-flex justify-content-center align-items-center flex-wrap">
		<label class="font-weight-bold text-white m-0 col-12 col-sm-6 text-center" style="font-size: 20px;">
			마스크거기 !
		</label>
<!-- 		<div class="col-12 col-sm-8 col-lg-4 d-flex" style="opacity: 1"> -->
<!-- 			<select id="region" class="form-control"></select> -->
<!-- 			<select id="sigungu" class="form-control mx-2"></select> -->
<!-- 			<select id="umd" class="form-control"></select> -->
<!-- 		</div> -->
	</header>
	
	<div id="map"></div>
	<button type="button" id="my_location" class="overlay-btn btn btn-dark" style="bottom: 5%; right: 5%;">
		<i class="material-icons">my_location</i>
	</button>
	
	<footer class="footer d-flex justify-content-between">
		<label class="font-weight-bold text-white m-0 px-2 text-center" style="font-size: 15px;">
			v0.1
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
					<div class="mb-5">
						<strong>
							공공데이터를 바탕으로 위치 기반 서비스를 통해 주위 마스크 판매처에서의 실시간 마스크 재고 및 현황을 제공합니다.
						</strong>
					</div>
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
				<div class="modal-footer">
					<a class="text-secondary font-weight-bold" href="javascript:announceRemind();">
						오늘 하루 보지않기
					</a>
				</div>
			</div>
		</div>
	</div>
	<script>
		let currentMarkers = [];
		let currentMarker = null;
		let currentInfoWindow = null;
		let currentOverlay = null;

		const announceRemind = function() {
			var date = new Date();
		    date.setDate(date.getDate() + 1);
		    
		    var cookie = "";
		    cookie += "ar=1;";
		    cookie += "expires=" + date.toUTCString();
		    
		    document.cookie = cookie;

			$('#announceModal').modal('hide')
		}
		
		const getAr = function() {
			var cookies = document.cookie.split(";");

	        // 쿠키를 추출한다.
	        for (var i in cookies) {
	            if (cookies[i].search('ar') != -1) {
	            	return true;
	            }
	        }	
	        return false;
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

		const fetchCoords = function(lat, lng) {
			$.ajax({
				url: '/search?lat=' + lat + '&lng=' + lng,
				type: 'GET',
				dataType: 'json',
				success: function(result) {
					const stores = result.stores;

					if (result.count <= 0) {
						return;
					}
					
					setMarkers(null);
					
					currentMarkers = [];
					markerDict = [];
					
					let latMax = 0;
					let latMin = 1000;
					let lngMax = 0;
					let lngMin = 1000;
					
					for (var i = 0; i < stores.length; i++) {
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
					    
					    var iwContent = '<div class="wrap">' + 
							            '    <div class="info">' + 
							            '        <div class="title">' +
						            				positions.name + 
							            '        </div>' + 
						                '        <div class="d-flex flex-wrap p-2" style="height: 125px;">' + 
						                '            <div class="addr">' + positions.addr + '</div>';
						                
					    let imageSrc = '';
						
					    if (positions.remain_stat == 'plenty') {
					    	imageSrc = plentySrc;
					    	iwContent += '<div class="ellipsis text-success">' + '재고 100개 이상' + '</div>';
					    } else if (positions.remain_stat == 'some') {
					    	imageSrc = someSrc;
					    	iwContent += '<div class="ellipsis text-warning">' + '재고 30개 ~ 100개' + '</div>';
					    } else if (positions.remain_stat == 'few') {
					    	imageSrc = fewSrc;
					    	iwContent += '<div class="ellipsis text-danger">' + '재고 2개 ~ 30개' + '</div>';
					    } else if (positions.remain_stat == 'empty') {
					    	imageSrc = emptySrc;
					    	iwContent += '<div class="ellipsis text-secondary">' + '재고 1개 이하' + '</div>';
					    }

		                iwContent +='			<div class="d-flex justify-content-between align-self-end col-12 mt-2">' + 
		                			'				<a class="btn btn-dark col-6 p-1" href="https://map.kakao.com/link/to/' + positions.name + ',' + lat + ',' + lng + '" target="_blank" style="margin-right: 5px; margin-left: -2.5px; font-size: 15px;">길찾기</a>' +
		                			'				<a class="btn btn-dark col-6 p-1" href="https://map.kakao.com/link/map/' + positions.name + ',' + lat + ',' + lng + '" target="_blank" style="font-size: 15px;">크게보기</a>' + 
	                				'			</div>' + 
					                '        </div>' + 
					                '    </div>' +    
					                '</div>';

		    			
					    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
					    
					    // 마커를 생성합니다
					    var marker = new kakao.maps.Marker({
					        map: map, // 마커를 표시할 지도
					        position: new kakao.maps.LatLng(positions.lat, positions.lng), // 마커를 표시할 위치
					        title : positions.name, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
					        image : markerImage // 마커 이미지 
					    });

					    currentMarkers.push(marker);
					    
					    markerDict.push({
					    	marker: marker,
					    	content: iwContent
					    });
			    			
						const index = i;
						
					    kakao.maps.event.addListener(marker, 'click', function() {
					    	const obj = markerDict[index];
					    	
				 	    	if (currentOverlay != null) {
				 	    		currentOverlay.setMap(null);
				 	    	}
				 	    	
					    	var overlay = new kakao.maps.CustomOverlay({
						        content: obj.content,
						        map: map,
						        position: obj.marker.getPosition()       
						    });
					    	
					    	currentOverlay = overlay;
				 	    	currentOverlay.setMap(map);
					    });
					}
				}
			});
		}
		
		let markerDict = [];
		
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
			const ar = getAr();
			if (!ar) {
				$('#announceModal').modal('show')
			}
			
			$('#map').height(window.innerHeight + 'px');

			$('#my_location').click(function(e) {
				myLocation();
			})

			myLocation();
			
// 			fetch('서울특별시 중구');
		});
		
		const myLocation = function() {
			if(navigator.geolocation) {
	            navigator.geolocation.getCurrentPosition(function(position) {
	            	const coords = position.coords;
	            	const latitude = coords.latitude;
	            	const longitude = coords.longitude;
	    
	            	fetchCoords(latitude, longitude);

					panTo(latitude, longitude);
					
	            }, function(error) {
	                console.log(error.message);
	            });
	        } else {
	            console.log("Geolocation을 지원하지 않는 브라우저 입니다.");
	        }
		}
		
		var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
		var options = { //지도를 생성할 때 필요한 기본 옵션
			center: new kakao.maps.LatLng(37.5667438, 126.9825913), //지도의 중심좌표.
			level: 6 //지도의 레벨(확대, 축소 정도)
		};
		
		var map = new kakao.maps.Map(container, options); // 지도를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder(); // 좌표계 변환 객체를 생성합니다

		kakao.maps.event.addListener(map, 'dragend', function() {        
		    var latlng = map.getCenter(); 

	    	if (currentOverlay != null) {
	    		currentOverlay.setMap(null);
	    	}
	    	
		    fetchCoords(latlng.getLat().toFixed(7), latlng.getLng().toFixed(7));
		});
		
		function makerClickListener(overlay) {
	        overlay.setMap(map);
		        
// 	    	if (currentInfoWindow != null) {
// 		    	currentInfoWindow.close();
// 	    	}
	    	
// 	    	currentMarker = marker;
// 	    	currentInfoWindow = infowindow;
	    	
// 	        infowindow.open(map, currentMarker);
	    }
		
		function panTo(lat, lng) {
		    var moveLatLon = new kakao.maps.LatLng(lat, lng);
		    map.panTo(moveLatLon);

	    	if (currentInfoWindow != null) {
		    	currentInfoWindow.close();
	    	}
		}    
		
		const plentySrc = "/icons/plenty.png";
		const someSrc = "/icons/some.png";
		const fewSrc = "/icons/few.png";
		const emptySrc = "/icons/empty.png";
	</script>
</body>
</html>