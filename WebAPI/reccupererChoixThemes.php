<?php
include_once("JSON.php");
$json = new Services_JSON();
$mysqli = new mysqli("localhost", "root", "root","db_ephemerides") or die("Could not connect");
$arr=array();
//test connexion
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

if($_POST)
{
// Variables qui détérminent le nom d'utilisateur et le mot de passe
$idclient=addslashes($_POST['idclient']);
//$idclient=1;
 

$sql="SELECT idTheme FROM ChoixTheme WHERE idClient='$idclient'";

$result=$mysqli->query($sql);
$obj=mysqli_fetch_assoc($result);

$count=mysqli_num_rows($result);

while( $obj=mysqli_fetch_assoc($result))
{
	$arr[]=$obj;
}
Echo $json->encode($arr);


}
mysqli_free_result($result);
?>
