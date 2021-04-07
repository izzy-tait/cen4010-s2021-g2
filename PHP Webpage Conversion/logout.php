<!DOCTYPE html>
<html lang="en">
    <head>
		<script type="text/javascript">
			function redir(){
				window.location = "https://lamp.cse.fau.edu/~cen4010_s21_g02/projectdemo/login.php";
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
		else {
			$membernumber = $_SESSION["MEMBER_NUMBER"];
			$username = $_SESSION["MEMBER_ID"];
			$firstname = $_SESSION["FIRST_NAME"];
			$lastname = $_SESSION["LAST_NAME"];
			$email = $_SESSION["EMAIL_ADDRESS"];
			
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
			$sqlcode = "call DEV_PROFILE_SET_STATUS_OFFLINE('$membernumber');";
			$result = $db->query($sqlcode);
			$db->close();
			session_destroy ( );
			echo "<body id='page-top' onload='redir();'>";
			echo "<center>Goodbye $firstname !</center>";
		}		
	?>	</body>
</html>