<?php
include_once("JSON.php");
$json = new Services_JSON();
$mysqli = new mysqli("localhost", "root", "root","db_ephemerides") or die("Could not connect");

//test connexion
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

//fonction pour rendre les caractères spéciaux d'une chaine lisible

function char($text)
{	
	$text = htmlentities($text, ENT_COMPAT, 'iso-8859-1');
	$text1 = htmlspecialchars_decode($text);
	return $text1;
}

//fonction pour rendre un tableau de chaine lisible
function frchar($tab)
{	
	foreach($tab as $clef => $valeur)
	{
		$tab[$clef]=char($valeur);
		
	}
	return $tab;
}
//requete
$arr = array();
$rs = $mysqli->query("SELECT * FROM ephemerides");
while( $obj=mysqli_fetch_assoc($rs))
{	
	$obj2=frchar($obj);
	$arr[]=$obj2;
}
 
Echo $json->encode($arr); 
//libérer les données réccupérées
mysqli_free_result($rs);

?>
