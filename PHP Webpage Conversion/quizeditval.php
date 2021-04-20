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
				window.location = "myquizzes.php";
			}
			function redir3(){
				window.location = "editquiz.php";
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
		elseif (!isset($_SESSION["QUIZ_NUMBER"])){
			echo "<body id='page-top' onload='redir2();'>";
		}
		elseif ($_SERVER["REQUEST_METHOD"] != "POST"){
			echo "<body id='page-top' onload='redir2();'>";
		}
		else {
			$membernumber = $_SESSION["MEMBER_NUMBER"];
			$quiznumber =  $_SESSION["QUIZ_NUMBER"];
			
			$quizname = $_POST["quizname"];
			$quizgenre = $_POST["quizgenre"];
			$passpercentage = floatval(floatval($_POST["passpercentage"])/floatval(100));
			
			$teamURL = dirname($_SERVER['PHP_SELF']) . DIRECTORY_SEPARATOR;
			$server_root = dirname($_SERVER['PHP_SELF']);
			$dbhost = 'localhost';  // Most likely will not need to be changed
			$dbname = 'cen4010_s21_g02';   // Needs to be changed to your designated table database name
			$dbuser = 'cen4010_s21_g02';   // Needs to be changed to reflect your LAMP server credentials
			$dbpass = 'Group02sec!'; // Needs to be changed to reflect your LAMP server credentials
			$db = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
			if($db->connect_errno > 0) {
				die('Unable to connect to database [' . $db->connect_error . ']');
			}
			$quizname =  mysqli_real_escape_string($db, $_POST["quizname"]);
			$quizgenre =  mysqli_real_escape_string($db, $_POST["quizgenre"]);
			$passpercentage = floatval(floatval($_POST["passpercentage"])/floatval(100));
			$sqlcode = "call DEV_QUIZ_CHANGE_QUIZ_HEADER_INFO('$membernumber','$quiznumber','$quizname','$quizgenre','$passpercentage');";
			$result = $db->query($sqlcode);
			$row = $result->fetch_assoc();
			$db->close();			
			echo "<body id='page-top' onload='redir3();'>";
			
		}	
	?>
	</body>
</html>
