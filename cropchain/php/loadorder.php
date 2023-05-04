<?php

include_once("dbconnect.php");

$sql = "SELECT * FROM tbl_order ORDER BY status ASC";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $orders["orders"] = array();

    while ($row = $result->fetch_assoc()) {
        $order = array();
        $order['order_id'] = $row['order_id'];
        $order['date_order'] = $row['date_order'];
        $order['total_price'] = $row['total_price'];
        $order['status'] = $row['status']  === "1" ? True : False;
        array_push($orders["orders"], $order);
    }

    $response = array('status' => 'success', 'data' => $orders);
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