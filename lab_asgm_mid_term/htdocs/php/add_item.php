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
$item_type = $_POST['itemtype'];
$state = $_POST['state'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$locality = $_POST['locality'];
$image = json_decode($_POST['image']);

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,`item_title`, `item_description`, `item_type`, `state`, `latitude`, `longitude`, `locality`) 
              VALUES ('$userid','$item_title','$item_description','$item_type','$state','$latitude','$longitude','$locality')";

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
