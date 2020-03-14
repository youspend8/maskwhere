<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
	
	</div>
	
	<footer class="footer d-flex justify-content-between">
		<label class="font-weight-bold text-white m-0 px-2 text-center" style="font-size: 15px;">
			v0.7
		</label>
		<label class="font-weight-bold text-white m-0 px-2 text-center" style="font-size: 15px;">
			������ ���� : chaehunbn@gmail.com
		</label>
	</footer>
	
	<div class="modal" id="announceModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title font-weight-bold">
						�˸�
					</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" style="font-size: 16px;">
					<div class="mb-5">
						<strong>
							���������͸� �������� ��ġ ��� ���񽺸� ���� ���� ����ũ �Ǹ�ó������ �ǽð� ����ũ ��� �� ��Ȳ�� �����մϴ�.<br><br>
							���� �̽� �������� �Ϻ� ���谡 �ִ� �ڷγ�19 ��Ȳ�� ���� ������ �����մϴ�.
						</strong>
					</div>
					<div class="mb-5">
						<strong>
							1. �ڷγ�19 ��Ȳ ��� �ð�ȭ ��Ʈ �߰�����
						</strong>
					</div>
					<div class="mb-2">
						<strong>
							P.S ������Ʈ UI/UX �����Ͽ� ���� �ֽǺ� ..
						</strong>
					</div>
					
					<p class="m-0 mt-4 text-right">
						���� ���� : 0.7<br>
						������ ��ó : ���������� ����
					</p>
				</div>
				<div class="modal-footer">
					<a class="text-secondary font-weight-bold" href="javascript:announceRemind();">
						���� �Ϸ� �����ʱ�
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

	