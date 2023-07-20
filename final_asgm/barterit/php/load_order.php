<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlorder = "SELECT * FROM `tbl_orders` WHERE user_id = '$userid'";
}

$result = $conn->query($sqlorder);

if ($result->num_rows > 0) {
    $orderitems["orders"] = array();
	while ($row = $result->fetch_assoc()) {
        $orderlist = array();
        $orderlist['order_id'] = $row['order_id'];
        $orderlist['order_bill'] = $row['order_bill'];
        $orderlist['order_paid'] = $row['order_paid'];
        $orderlist['user_id'] = $row['user_id'];
        $orderlist['seller_id'] = $row['seller_id'];
        $orderlist['order_date'] = $row['order_date'];
        array_push($orderitems["orders"] ,$orderlist);
    }
    $response = array('status' => 'success', 'data' => $orderitems);
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