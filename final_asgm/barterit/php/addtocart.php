<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['item_id'];
$itemtitle = $_POST['item_title'];
$cartprice = $_POST['cart_price'];
$userid = $_POST['user_id'];
$sellerid = $_POST['seller_id'];

$checkitemid = "SELECT * FROM `tbl_carts` WHERE `user_id` = '$userid' AND `item_id` = '$itemid'";

$resultqty = $conn->query($checkitemid);
$numresult = $resultqty->num_rows;
if ($numresult > 0) {
	$sql = "UPDATE `tbl_carts` SET `cart_price`= (cart_price+$cartprice) WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";

}else{
	$sql = "INSERT INTO `tbl_carts`(`item_id`,`item_title`, `cart_price`, `user_id`, `seller_id`) VALUES ('$itemid','$itemtitle','$cartprice','$userid','$sellerid')";
}

if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => $sql);
		sendJsonResponse($response);
	}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>