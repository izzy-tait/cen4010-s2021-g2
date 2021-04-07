<!DOCTYPE html>
<html lang="en">
	<head>
		<script type="text/javascript">
			function redirect(){
				window.location = "https://lamp.cse.fau.edu/~cen4010_s21_g02/projectdemo/";
			}
			function redirect2(){
				window.location = "https://lamp.cse.fau.edu/~cen4010_s21_g02/projectdemo/profileeditf.php";
			}
			function redirect3(){
				window.location = "https://lamp.cse.fau.edu/~cen4010_s21_g02/projectdemo/home.php";
			}
		</script>
	</head>
	<?
		session_name('Usersession');
		session_start();
		if (!isset($_SESSION["MEMBER_NUMBER"])) {
			session_destroy ( );
			echo "<body id='page-top' onload='redirect();'>";
		}
		else {
			$teamURL = dirname($_SERVER['PHP_SELF']) . DIRECTORY_SEPARATOR;
			$server_root = dirname($_SERVER['PHP_SELF']);
			$dbhost = 'localhost';  // Most likely will not need to be changed
			$dbname = 'cen4010_s21_g02';   // Needs to be changed to your designated table database name
			$dbuser = 'cen4010_s21_g02';   // Needs to be changed to reflect your LAMP server credentials
			$dbpass = 'Group02sec!'; // Needs to be changed to reflect your LAMP server credentials
			
			$membernumber = $_SESSION["MEMBER_NUMBER"];
			$oldusername = $_SESSION["MEMBER_ID"];
			$oldfirstname = $_SESSION["FIRST_NAME"];
			$oldlastname = $_SESSION["LAST_NAME"];
			$oldemail = $_SESSION["EMAIL_ADDRESS"];
			
			$newusername = $_POST["username"];
			$newfirstname =  $_POST["firstname"];
			$newlastname = $_POST["lastname"];
			$newemail = $_POST["email"];
			$newpassword = $_POST["password"];
			$newpassword = crypt($newpassword,'st');
			
			if ($newusername == $oldusername){
				$db = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
				if($db->connect_errno > 0) {
					die('Unable to connect to database [' . $db->connect_error . ']');
				}
				$sqlcode = "call DEV_PROFILE_UPDATE_PROFILE('$membernumber','$newusername','$newfirstname','$newlastname','$newemail','1');";
				$result = $db->query($sqlcode);
				$row = $result->fetch_assoc();
				$db->close();
				$db3 = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
				if($db3->connect_errno > 0) {
					die('Unable to connect to database [' . $db3->connect_error . ']');
				}
				$sqlcode3 = "call DEV_PROFILE_CHANGE_PASSWORD('$membernumber','$newpassword');";
				$result3 = $db3->query($sqlcode3);
				$row3 = $result3->fetch_assoc();
				$db3->close();
				$_SESSION["MEMBER_ID"] = $row["MEMBER_ID"];
				$_SESSION["FIRST_NAME"] = $row["FIRST_NAME"];
				$_SESSION["LAST_NAME"] = $row["LAST_NAME"];
				$_SESSION["EMAIL_ADDRESS"] = $row["EMAIL_ADDRESS"];
				echo "<body id='page-top' onload='redirect3();'>";
			}
			else {
				$db1 = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
				if($db1->connect_errno > 0) {
					die('Unable to connect to database [' . $db1->connect_error . ']');
				}
				$sqlcode1 = "call DEV_PROFILE_IF_USERNAME_EXISTS('$newusername',@validate);";
				$result1 = $db1->query($sqlcode1);
				$row1 = $result1->fetch_assoc();
				$db1->close();
				if ($row1["DOES_EXIST"] == 0){
					$db = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
					if($db->connect_errno > 0) {
						die('Unable to connect to database [' . $db->connect_error . ']');
					}
					$sqlcode = "call DEV_PROFILE_UPDATE_PROFILE('$membernumber','$newusername','$newfirstname','$newlastname','$newemail','1');";
					$result = $db->query($sqlcode);
					$row = $result->fetch_assoc();
					$db->close();
					$db3 = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
					if($db3->connect_errno > 0) {
						die('Unable to connect to database [' . $db3->connect_error . ']');
					}
					$sqlcode3 = "call DEV_PROFILE_CHANGE_PASSWORD('$membernumber','$newpassword');";
					$result3 = $db3->query($sqlcode3);
					$row3 = $result3->fetch_assoc();
					$db3->close();
					$_SESSION["MEMBER_ID"] = $row["MEMBER_ID"];
					$_SESSION["FIRST_NAME"] = $row["FIRST_NAME"];
					$_SESSION["LAST_NAME"] = $row["LAST_NAME"];
					$_SESSION["EMAIL_ADDRESS"] = $row["EMAIL_ADDRESS"];
					echo "<body id='page-top' onload='redirect3();'>";
				}
				else {
					echo "<body id='page-top' onload='redirect2();'>";
				}
				
			}			
		}		
	?>
	
		</body>
</html>
