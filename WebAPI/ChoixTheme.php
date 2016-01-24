<?php
include_once("JSON.php");
$json = new Services_JSON();
$mysqli = new mysqli("localhost", "root", "root","ephemerides") or die("Could not connect");

//test connexion
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}
//requete
$arr = array();
$rs = $mysqli->query("SELECT Titre, Jour, Mois FROM ephemerides WHERE Jour=4 and Mois=3");
while( $obj=mysqli_fetch_assoc($rs))
{
	$arr[]=$obj;
}
 
Echo $json->encode($arr);
//libérer les données réccupérées
mysqli_free_result($rs);

?>