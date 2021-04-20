<html>
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
				window.location = "searchquiz.php";
			}
			function redir3(){
				window.location = "searchquiz.php";
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
		elseif (!$_SERVER["REQUEST_METHOD"] == "POST") {
			echo "<body id='page-top' onload='redir2();'>";
		}
		else{
			$quiznumber = $_POST["currentquiz"];
			$_SESSION["QUIZ_NUMBER"] = $quiznumber;
			
			$teamURL = dirname($_SERVER['PHP_SELF']) . DIRECTORY_SEPARATOR;
			$server_root = dirname($_SERVER['PHP_SELF']);
			$dbhost = 'localhost';  // Most likely will not need to be changed
			$dbname = 'cen4010_s21_g02';   // Needs to be changed to your designated table database name
			$dbuser = 'cen4010_s21_g02';   // Needs to be changed to reflect your LAMP server credentials
			$dbpass = 'Group02sec!'; // Needs to be changed to reflect your LAMP server credentials
			$db = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
			$sqlcode = "SELECT * FROM DEV_QUIZ_HEADER WHERE QUIZ_NUMBER = 'QUIZ10003-974';";
			$result = $db->query($sqlcode);
			$row = $result->fetch_assoc();
			$db->close();
			echo "<body id='page-top'>";
			echo row["QUIZ_NAME"];
			echo row["QUIZ_GENRE"];
		}
		?>
	</body>
</html>