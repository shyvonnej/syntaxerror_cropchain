<?php
include_once("dbconnect.php");

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

if (isset($_GET['product_id'])) {
    $product_id = $_GET['product_id'];

    // join two tables to retrieve the required data
    $sqlload = "SELECT tbl_inventory.*, tbl_product.product_name
                FROM tbl_inventory
                INNER JOIN tbl_product ON tbl_inventory.product_id = tbl_product.product_id
                WHERE tbl_inventory.product_id = '$product_id'";

    $result = $conn->query($sqlload);

    if ($result !== false && $result->num_rows > 0) {
        $inventory = array(); // initialize $inventory as an empty array

        while ($row = $result->fetch_assoc()) {
            $item = array();
            $item['batch_id'] = $row['batch_id'];
            $item['batch_num'] = $row['batch_num'];
            $item['date_of_production'] = $row['date_of_production'];
            $item['quantity'] = $row['quantity'];
            $item['date_best_before'] = $row['date_best_before'];
            $item['product_name'] = $row['product_name'];
            array_push($inventory, $item); // push $item to $inventory
        }

        $response = array('status' => 'success', 'data' => array('inventory' => $inventory));
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'No matching data', 'data' => null);
        sendJsonResponse($response);
    }
}
?>
