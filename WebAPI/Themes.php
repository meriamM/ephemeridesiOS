<?php
include_once("JSON.php");
$json = new Services_JSON();
$mysqli = new mysqli("localhost", "root", "root","db_ephemerides") or die("Could not connect");

//test connexion
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}
//requete
$arr = array();
$rs = $mysqli->query("SELECT * FROM Themes");
while( $obj=mysqli_fetch_assoc($rs))
{
	$arr[]=$obj;
}
 
Echo $json->encode($arr);
//libérer les données réccupérées
mysqli_free_result($rs);

?>