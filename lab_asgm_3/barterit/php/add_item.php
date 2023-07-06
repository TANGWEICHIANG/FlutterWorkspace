<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_title = $_POST['itemtitle'];
$item_description = $_POST['itemdesc'];
// $item_quantity = $_POST['itemqty'];
$item_type = $_POST['itemtype'];
$item_price = $_POST['itemprice'];
$item_state = $_POST['itemstate'];
$item_latitude = $_POST['itemlatitude'];
$item_longitude = $_POST['itemlongitude'];
$item_locality = $_POST['itemlocality'];
$image = json_decode($_POST['image']);

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,`item_title`, `item_description`, `item_type`, `item_price`, `item_state`, `item_latitude`, `item_longitude`, `item_locality`) 
              VALUES ('$userid','$item_title','$item_description','$item_type','$item_price','$item_state','$item_latitude','$item_longitude','$item_locality')";

if ($conn->query($sqlinsert) === TRUE) {
    $itemId = $conn->insert_id; 
    $response = array('status' => 'success', 'data' => null);
    $filename = $itemId;
    
    foreach ($image as $index => $base64Image) {
        $imageData = base64_decode($base64Image);

        if ($index > 0) {
            $filename = $itemId . '.' . $index; // Append the index if it's greater than 0
        }
        $path = '../assets/items/' . $filename . '.png';
        file_put_contents($path, $imageData);
    }
} else {
    $response = array('status' => 'failed', 'data' => null);
}
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
