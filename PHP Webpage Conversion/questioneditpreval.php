<!DOCTYPE html>
<html lang="en">
	<head>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-BVMDDB5FX1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-BVMDDB5FX1');
</script>
		<script type="text/javascript">
			function redir(){
				window.location = "login.php";
			}
			function redir2(){
				window.location = "editquiz.php";
			}
			function redir3(){
				window.location = "editquestion.php";
			}
		</script>
	</head>
	<?
		session_name('Usersession');
		session_start();
		if (!isset($_SESSION["MEMBER_NUMBER"])) {
			session_destroy ( );
			echo "<body id='page-top' onload='redir();'>";
		}
		elseif ($_SERVER["REQUEST_METHOD"] != "POST"){
			echo "<body id='page-top' onload='redir2();'>";
		}
		else {
			$membernumber = $_SESSION["MEMBER_NUMBER"];
			$currentquestion = $_POST["currentquestion"];
			$_SESSION["QUESTION_NUMBER"] = $currentquestion;			
			echo "<body id='page-top' onload='redir3();'>";			
		}	
	?>
	</body>
</html>
