<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['itemid'];
$item_title = $_POST['itemtitle'];
$item_description = addslashes($_POST['itemdescription']);
$item_type = $_POST['itemtype'];
$item_price = $_POST['itemprice'];

$sqlupdate = "UPDATE `tbl_items` SET `item_title`='$item_title',`item_type`='$item_type',`item_description`='$item_description',`item_price`='$item_price' WHERE `item_id`='$itemid'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>