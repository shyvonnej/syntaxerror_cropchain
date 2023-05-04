<?php
include_once("dbconnect.php");

// Select all inventory items with quantity 0
$sql = "SELECT * FROM tbl_inventory WHERE quantity = 0";
$result = $conn->query($sql);

// Delete each inventory item with quantity 0
while ($row = $result->fetch_assoc()) {
    $product_id = $row['product_id'];
    $sql_delete = "DELETE FROM tbl_inventory WHERE product_id = '$product_id'";
    $conn->query($sql_delete);
}
?>