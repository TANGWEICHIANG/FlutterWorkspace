<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];	
$sqlcart = "SELECT * FROM `tbl_carts` INNER JOIN `tbl_items` ON tbl_carts.item_id = tbl_items.item_id WHERE tbl_carts.user_id = '$userid'";


$result = $conn->query($sqlcart);
if ($result->num_rows > 0) {
    $cartitems["carts"] = array();
	while ($row = $result->fetch_assoc()) {
        $cartlist = array();
        $cartlist['cart_id'] = $row['cart_id'];
        $cartlist['item_id'] = $row['item_id'];
        $cartlist['item_title'] = $row['item_title'];
        $cartlist['cart_price'] = $row['cart_price'];
        $cartlist['user_id'] = $row['user_id'];
        $cartlist['seller_id'] = $row['seller_id'];
        array_push($cartitems["carts"] ,$cartlist);
    }
    $response = array('status' => 'success', 'data' => $cartitems);
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