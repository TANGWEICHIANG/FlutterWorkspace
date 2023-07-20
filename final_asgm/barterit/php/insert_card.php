<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$card_name = $_POST['cardname'];
$card_num = $_POST['cardnum'];
//$card_num = str_replace(' ', '', $_POST['cardnum']);
$card_month = $_POST['cardmonth'];
$card_year = $_POST['cardyear'];
$card_cvv = $_POST['cardcvv'];
$card_type = $_POST['cardtype'];

$sqlinsert = "INSERT INTO `tbl_cards`(`user_id`, `card_name`, `card_number`, `card_month`, `card_year`, `card_cvv`, `card_type`) VALUES ('$userid','$card_name','$card_num','$card_month','$card_year','$card_cvv','$card_type')";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlinsert);
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