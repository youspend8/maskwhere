<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<jsp:include page="header.jsp" />
	
	<div id="map"></div>
	
	<button type="button" id="my_location" class="overlay-btn btn btn-dark" style="bottom: 5%; right: 5%;">
		<i class="material-icons">my_location</i>
	</button>
	
	<select id="quick_panto" class="form-control text-white bg-dark">
		<option disabled selected hidden>빠른이동</option>
		<option value="37.5678430,126.9825230,8">서울</option>
		<option value="37.4560890,126.7059180,8">인천</option>
		<option value="35.8721442,128.6010148,8">대구</option>
		<option value="36.3607932,127.3795372,8">대전</option>
		<option value="35.1796181,129.0746697,8">부산</option>
		<option value="36.5004936,127.2811008,8">세종</option>
		<option value="35.1603806,126.8509929,8">광주</option>
		<option value="35.5407615,129.3139520,8">울산</option>
		<option value="33.3642451,126.5306645,8">제주도</option>
		<option value="37.5727451,127.0118633,10">경기도</option>
		<option value="36.9081212,127.7651757,10">충청북도</option>
		<option value="36.5853136,126.9724670,10">충청남도</option>
		<option value="36.4909804,128.6409779,10">경상북도</option>
		<option value="35.4526437,128.4814627,10">경상남도</option>
		<option value="37.7985088,128.2887330,10">강원도</option>
		<option value="35.7270600,127.0626041,10">전라북도</option>
		<option value="34.9229341,126.9583250,10">전라남도</option>
	</select>
	
	<jsp:include page="footer.jsp" />
	
	<script>
		let currentMarkers = [];
		let currentMarker = null;
		let currentInfoWindow = null;
		let currentOverlay = null;

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
						                '        <div class="d-flex flex-wrap p-2" style="height: 141px;">' + 
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
					    } else if (positions.remain_stat == 'break') {
					    	imageSrc = emptySrc;
					    	iwContent += '<div class="ellipsis text-secondary">' + '판매중지' + '</div>';
					    } else if (positions.remain_stat == null) {
					    	imageSrc = emptySrc;
					    	iwContent += '<div class="ellipsis text-secondary">' + '재고정보 없음' + '</div>';
					    }
					    
					    if (positions.created_at == null) {
							iwContent +='			<div class="ellipsis text-dark w-100">갱신시간 : ' + '정보없음' + '</div>';
					    } else {
							iwContent +='			<div class="ellipsis text-dark w-100">갱신시간 : ' + positions.created_at + '</div>';
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
		
		$(document).ready(function() {
			const ar = getAr();
			if (!ar) {
				$('#announceModal').modal('show')
			}
			
			$('#map').height(window.innerHeight + 'px');

			$('#my_location').click(function(e) {
				myLocation();
			})

			$('#quick_panto').change(function(e) {
				const coords = e.target.value;
				const spl = coords.split(',');
				
				if (spl.length == 3) {
					const lat = Number.parseFloat(spl[0]);
					const lng = Number.parseFloat(spl[1]);
					const level = Number.parseInt(spl[2]);
					
					map.setLevel(level);

	            	fetchCoords(lat, lng);
	            	
					panTo(lat, lng);
				}
			})
			
			myLocation();
		});
		
		const myLocation = function() {
			if(navigator.geolocation) {
	            navigator.geolocation.getCurrentPosition(function(position) {
	            	const coords = position.coords;
	            	const latitude = coords.latitude;
	            	const longitude = coords.longitude;
	    
	            	fetchCoords(latitude, longitude);

					panTo(latitude, longitude);

					var marker = new kakao.maps.Marker({
				        map: map, // 마커를 표시할 지도
				        position: new kakao.maps.LatLng(latitude, longitude),
				        title : '현재위치',
				        image : new kakao.maps.MarkerImage('/icons/current.png', new kakao.maps.Size(20, 20))
				    });
					
					if (currentMarker != null) {
						currentMarker.setMap(null);	
					}
					currentMarker = marker;
					currentMarker.setMap(map);
					
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
		
		function panTo(lat, lng) {
		    var moveLatLon = new kakao.maps.LatLng(lat, lng);
		    map.panTo(moveLatLon);

	    	if (currentOverlay != null) {
	    		currentOverlay.setMap(null);
	    	}
		}    
		
		const plentySrc = "/icons/plenty.png";
		const someSrc = "/icons/some.png";
		const fewSrc = "/icons/few.png";
		const emptySrc = "/icons/empty.png";
	</script>
</body>
</html>