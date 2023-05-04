<?php
// Get the product ID from the request
$product_id = $_POST['product_id'];

// Include database connection
include_once("dbconnect.php");

// Delete the product from the database
$sql = "DELETE FROM tbl_product WHERE product_id = $product_id";

if ($conn->query($sql) === TRUE) {
    echo "success";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>