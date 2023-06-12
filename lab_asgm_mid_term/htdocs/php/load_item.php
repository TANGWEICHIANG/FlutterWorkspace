<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
$result = $conn->query($sqlloaditems);
if ($result->num_rows > 0) {
    $items["items"] = array();

while ($row = $result->fetch_assoc()) {
    $itemlist = array();
    $itemlist['item_id'] = $row['item_id'];
    $itemlist['user_id'] = $row['user_id'];
    $itemlist['item_title'] = $row['item_title'];
    $itemlist['item_description'] = $row['item_description'];
    $itemlist['item_type'] = $row['item_type'];
    $itemlist['state'] = $row['state'];
    $itemlist['latitude'] = $row['latitude'];
    $itemlist['longitude'] = $row['longitude'];
    $itemlist['locality'] = $row['locality'];
    $itemlist['item_created_at'] = $row['item_created_at'];
    array_push($items["items"],$itemlist);
}

$response = array('status' => 'success', 'data' => $items);
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