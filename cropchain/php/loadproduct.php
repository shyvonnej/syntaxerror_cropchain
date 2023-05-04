<?php

include_once("dbconnect.php");

$sql = "SELECT * FROM tbl_product";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $products["products"] = array();

    while ($row = $result->fetch_assoc()) {
        $product = array();
        $product['product_id'] = $row['product_id'];
        $product['product_name'] = $row['product_name'];
        $product['shelf_life'] = $row['shelf_life'];
        $product['total_quantity'] = $row['total_quantity'];
        $product['price'] = $row['price'];
        array_push($products["products"], $product);
    }

    $response = array('status' => 'success', 'data' => $products);
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