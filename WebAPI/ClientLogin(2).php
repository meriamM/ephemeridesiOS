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
// Variables qui détérminent le nom d'utilisateur et le mot de passe
$username=addslashes($_POST['username']); 
$password=addslashes($_POST['password']); 

$sql="SELECT id FROM Client WHERE username='$username' and motdePasse='$password'";
$result=$mysqli->query($sql);
$row=mysqli_fetch_assoc($result);
//$active=$row['active'];
$count=mysqli_num_rows($result);


// si le mot de passe et le nom d'utilisateur sont corrects alors $count=1
if($count==1)
{
    echo '{"success":1}';
}
else {
    echo '{"success":0,"error_message":"Username et/ou mot de passe incorrect."}';

}
}
else 
{
 echo '{"success":0,"error_message":"username et/ou mot de passe incorrect post."}';
}


?>
