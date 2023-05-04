<?php
include_once("dbconnect.php");

// Get the maximum value of the product_id column from the tbl_product table
$sql = "SELECT MAX(product_id) as max_id FROM tbl_product";
$result = $conn->query($sql);
$row = mysqli_fetch_assoc($result);
$max_id = $row['max_id'];

// Set the auto_increment value of the product_id column to be the maximum value + 1
$sql = "ALTER TABLE tbl_product AUTO_INCREMENT = " . ($max_id + 1);
$conn->query($sql);

// Get the product information from the form
$productname = $_POST["product_name"];
$shelflife = $_POST["shelf_life"];
$price = $_POST["price"];

// Prepare and bind SQL statement
$sqlinsert = "INSERT INTO tbl_product (product_name, shelf_life, price) VALUES ('$productname', '$shelflife', '$price')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
