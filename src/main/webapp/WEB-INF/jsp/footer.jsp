<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
	
	</div>
	
	<footer class="footer d-flex justify-content-between">
		<label class="font-weight-bold text-white m-0 px-2 text-center" style="font-size: 15px;">
			v0.7
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
							공공데이터를 바탕으로 위치 기반 서비스를 통해 주위 마스크 판매처에서의 실시간 마스크 재고 및 현황을 제공합니다.<br><br>
							또한 이슈 기준으로 일부 관계가 있는 코로나19 현황에 대한 정보를 제공합니다.
						</strong>
					</div>
					<div class="mb-5">
						<strong>
							1. 코로나19 현황 통계 시각화 차트 추가예정
						</strong>
					</div>
					<div class="mb-2">
						<strong>
							P.S 웹사이트 UI/UX 관련하여 도움 주실분 ..
						</strong>
					</div>
					
					<p class="m-0 mt-4 text-right">
						배포 버전 : 0.7<br>
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
		const announceRemind = function() {
			var date = new Date();
		    date.setDate(date.getDate() + 1);
		    
		    var cookie = "";
		    cookie += "ar=1;";
		    cookie += "expires=" + date.toUTCString();
		    
		    document.cookie = cookie;
	
			$('#announceModal').modal('hide')
		}
	
		$(document).ready(function() {
			$('#sidebar_close').click(function(e) {
				sidebarClose();
			});
			
			$('#sidebar_open').click(function(e) {
				sidebarOpen();
			});
			
			$(window).resize(function(e) {
				$('#wrapper').height(window.innerHeight + 'px');
				$('#map').height(window.innerHeight + 'px');
			});
		});

		const sidebarClose = function() {
			$('#sidebar').animate({
				left: '-300px'
			}, 300);
		}
		
		const sidebarOpen = function() {
			$('#sidebar').animate({
				left: '0px'
			}, 300);
		}
	</script>
</body>

	