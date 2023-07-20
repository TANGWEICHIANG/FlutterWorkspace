<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 10;
if (isset($_POST['pageno'])){
	$pageno = (int)$_POST['pageno'];
}else{
	$pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlloaditem = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
}else if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloaditem = "SELECT * FROM `tbl_items` WHERE item_title LIKE '%$search%'";
}else{
	$sqlloaditem = "SELECT * FROM `tbl_items`";
}

$result = $conn->query($sqlloaditem);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloaditem = $sqlloaditem . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloaditem);

if ($result->num_rows > 0) {
    $items["items"] = array();
	while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_title'] = $row['item_title'];
        $itemlist['item_description'] = $row['item_description'];
		$itemlist['item_type'] = $row['item_type'];
        $itemlist['item_price'] = $row['item_price'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_latitude'] = $row['item_latitude'];
        $itemlist['item_longitude'] = $row['item_longitude'];
        $itemlist['item_locality'] = $row['item_locality'];
		$itemlist['item_created_at'] = $row['item_created_at'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items, 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result");
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
