<?php
include_once("dbconnect.php");

if (isset($_POST['product_id'])) {
    $product_id = $_POST['product_id'];

    // Get the maximum value of the batch_num column from the tbl_inventory table
    $sql = "SELECT MAX(batch_num) as max_num FROM tbl_inventory";
    $result = $conn->query($sql);
    $row = mysqli_fetch_assoc($result);
    $max_num = $row['max_num'];

    // Generate a unique batch number that is not already in the database
    do {
        $batch_num = str_pad(mt_rand(1,999999), 6, '0', STR_PAD_LEFT);
        $sql = "SELECT batch_num FROM tbl_inventory WHERE batch_num = '$batch_num'";
        $result = $conn->query($sql);
        $num_rows = mysqli_num_rows($result);
    } while ($num_rows > 0);

    // Get the inventory information from the form
    $productiondate = $_POST["date_of_production"];
    $quantity = $_POST["quantity"];

    // Prepare and bind SQL statement
    $sqlinsert = "INSERT INTO tbl_inventory (batch_num, date_of_production, quantity, product_id) VALUES ('$batch_num', '$productiondate', '$quantity', '$product_id');";

    if ($conn->query($sqlinsert) === TRUE) {
        $last_id = mysqli_insert_id($conn);
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);

        // Update total_quantity of tbl_product
        $sqlupdate = "UPDATE tbl_product p SET p.total_quantity = (SELECT SUM(quantity) FROM tbl_inventory WHERE product_id = '$product_id') WHERE p.product_id = '$product_id'";
        if ($conn->query($sqlupdate) === FALSE) {
            error_log("Error updating total_quantity of tbl_product: " . $conn->error);
        }
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
