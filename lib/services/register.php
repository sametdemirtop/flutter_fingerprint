<?php
	include 'conn.php';
	if (!$db) {
		echo "Database connection faild";
	}

	$name = $_POST['name'];
    $email = $_POST['email'];
	$password = $_POST['password'];
    $accessrole = $_POST['accessrole'];
    $location = $_POST['location'];

	$sql = "SELECT email FROM users WHERE email = '".$email."'";

	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	if ($count == 1) {
		echo json_encode("Error");
	}
    else
    {
		$insert = "INSERT INTO users(name,email,password,accessrole,location)VALUES('".$name."','".$email."','".$password."','".$accessrole."','".$location."')";
		$query = mysqli_query($db,$insert);
		if ($query) {
			echo json_encode("Success");
		}
	}

?>