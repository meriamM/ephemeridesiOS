<?php
include_once("JSON.php");
$json = new Services_JSON();
$mysqli = new mysqli("localhost", "root", "root","db_ephemerides") or die("Could not connect");

//test connexion
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

if($_POST)
{
// Variables qui contiennent les données de l'utilisateur
$idclient=addslashes($_POST['idclient']);
$idtheme=addslashes($_POST['idtheme']); 




$sql="INSERT INTO ChoixTheme VALUES ($idclient,$idtheme)";
$succes= mysqli_query($mysqli, $sql);
 
 if($succes) //l'insertion s'est bien déroulée
 {
 	 echo '{"success":1}'; 
 }
 else
 {
 	 echo '{"success":0}'; //probablement parce que le username est le même
 }


}
else 
{
 echo '{"success":0,"error_message":"un probleme lors de l insertion"}';
}


?>