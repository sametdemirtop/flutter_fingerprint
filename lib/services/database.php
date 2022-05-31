<?php 

	include 'conn.php';

	if ($db->connect_errno) {
		printf('faild database connect',$db->connect_errno);
		exit();
	}

?>