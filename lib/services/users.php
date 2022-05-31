<?php 

	
     include 'conn.php';

     if ($db->connect_errno) {
     printf('faild database connect',$db->connect_errno);
     exit();
     }

     $email = $_POST['email'];

	$query = $db->query("SELECT * FROM users WHERE email = '".$email."'");
	$result = array();

	while ($rowData = $query->fetch_assoc()) {
		$result[] = $rowData;
	}


	echo json_encode($result);
 ?>