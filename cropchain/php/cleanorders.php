<?php
include_once("dbconnect.php");

// Retrieve all the order_id where the status is 1
$sql = "SELECT order_id FROM tbl_order WHERE status = '1'";
$result = $conn->query($sql);

// Loop through the result set and delete the details in order_product table for each order_id
while ($row = $result->fetch_assoc()) {
    $order_id = $row['order_id'];
    $sql = "DELETE FROM order_product WHERE order_id = '$order_id'";
    $conn->query($sql);
}

// Delete orders where the status is true/1
$sql = "DELETE FROM tbl_order WHERE status = '1'";
if ($conn->query($sql) === TRUE) {
    echo "Orders deleted successfully";
} else {
    echo "Error deleting orders: " . $conn->error;
}

$conn->close();
?>
