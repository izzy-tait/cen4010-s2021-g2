<!DOCTYPE html>
<html lang="en">
	<head>
		<script type="text/javascript">
			function redirect(){
				window.location = "https://lamp.cse.fau.edu/~cen4010_s21_g02/projectdemo/";
			}
			function redirect2(){
				window.location = "https://lamp.cse.fau.edu/~cen4010_s21_g02/projectdemo/loginf.php";
			}
			function redirect3(){
				window.location = "https://lamp.cse.fau.edu/~cen4010_s21_g02/projectdemo/home.php";
			}
		</script>
	</head>
	<?
		if ($_SERVER["REQUEST_METHOD"] == "POST") {
			$username = $_POST["username"];
			$password = $_POST["password"];
			$password = crypt($password,'st');
			
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
			else {
				$sqlcode1 = "SELECT * FROM `DEV_MEMBER_PROFILE` WHERE MEMBER_ID = '$username' AND ENCRYPT_PASSWORD = '$password' AND MEMBER_BAN_FLAG = 0 AND LOGICAL_DELETE_FLAG = 0;";
				$result1 = $db->query($sqlcode1);
				$db->close();
				if ($result1->num_rows === 0){
					echo "<body onload='redirect2();'>";
				}
				else {
					$rows1 = $result1->fetch_assoc();
					session_name( 'Usersession' );
					session_start();
					$_SESSION["MEMBER_NUMBER"] = $rows1["MEMBER_NUMBER"];
					$_SESSION["MEMBER_ID"] = $rows1["MEMBER_ID"];
					$_SESSION["FIRST_NAME"] = $rows1["FIRST_NAME"];
					$_SESSION["LAST_NAME"] = $rows1["LAST_NAME"];
					$_SESSION["EMAIL_ADDRESS"] = $rows1["EMAIL_ADDRESS"];
					$db2 = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
					if($db2->connect_errno > 0) {
						die('Unable to connect to database [' . $db->connect_error . ']');
					}
					else{
						$sqlcode2 = "call DEV_PROFILE_SET_STATUS_ONLINE('".$rows1["MEMBER_NUMBER"]."');";
						$result2 = $db2->query($sqlcode2);
						$db2->close();
						echo "<body onload='redirect3();'>";
						echo "<center>Please wait . . . </center>";
					}
				}
			}			
		}
		else {
			echo "<body onload='redirect();'>";	
		}	
	?>
	</body>
</html>
