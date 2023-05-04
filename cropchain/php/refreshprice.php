<?php
include_once("dbconnect.php");

$sql = "UPDATE tbl_order o SET o.total_price = (
  SELECT SUM(p.price * op.quantity_buy)
  FROM order_product op
  JOIN tbl_product p ON op.product_id = p.product_id
  WHERE op.order_id = o.order_id
)";
if ($conn->query($sql) === TRUE) {
    echo "Total prices updated successfully";
} else {
    echo "Error updating total prices: " . $conn->error;
}

$conn->close();
?>
