<?php
include_once("dbconnect.php");

if (isset($_POST['order_id'])) {
    // Get the order ID from the request
    $orderid = $_POST['order_id'];

    // Retrieve the list of products and their quantities for the order from tbl_product_order
    $sql = "SELECT * FROM order_product WHERE order_id = '$orderid'";
    $result = $conn->query($sql);

    $inventory_updated = false;
    

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $product_id = $row['product_id'];
            $quantity_to_reduce = $row['quantity_buy'];
            $batch_id_used = null;

            // Retrieve the oldest inventory batches with enough quantity to reduce for the specific product
            $sql = "SELECT * FROM tbl_inventory WHERE product_id = '$product_id' AND quantity > 0 ORDER BY date_of_production ASC";
            $inventory_result = $conn->query($sql);

            $total_quantity_to_reduce = $quantity_to_reduce;

            if ($inventory_result->num_rows > 0) {
                while ($inventory_row = $inventory_result->fetch_assoc()) {
                    $batch_id = $inventory_row['batch_id'];
                    $batch_quantity = $inventory_row['quantity'];

                    // Check if the current batch has enough quantity to fulfill the remaining quantity
                    if ($batch_quantity >= $total_quantity_to_reduce) {
                        // Calculate the remaining quantity in the batch
                        $remaining_quantity = $batch_quantity - $total_quantity_to_reduce;
                        $batch_id_used = $batch_id;

                        // Update the inventory batch with the remaining quantity
                        $sql = "UPDATE tbl_inventory SET quantity = '$remaining_quantity' WHERE batch_id = '$batch_id'";
                        if ($conn->query($sql) === TRUE) {
                            $inventory_updated = true;
                        } else {
                            echo "Error updating inventory: " . $conn->error;
                            $response = array('status' => 'failed', 'data' => null);
                            sendJsonResponse($response);
                        }
                        break;
                    } else {
                        // Subtract the batch quantity from the total quantity to reduce
                        $total_quantity_to_reduce -= $batch_quantity;
                        $batch_id_used = $batch_id;
                    }
                }
            }

            if ($inventory_updated) {
                $sql = "UPDATE order_product SET batch_number = '$batch_id_used' WHERE product_id = '$product_id' AND order_id = '$orderid'";
                if ($conn->query($sql) === TRUE) {
                    // echo "Batch id updated successfully";
                } else {
                    echo "Error updating batch id: " . $conn->error;
                    $response = array('status' => 'failed', 'data' => null);
                    sendJsonResponse($response);
                }

                // Update the total quantity in tbl_product
                $sql = "SELECT SUM(quantity) AS total_quantity FROM tbl_inventory WHERE product_id = '$product_id'";
                $inventory_result = $conn->query($sql); // Use a different variable here
                $row = $inventory_result->fetch_assoc();
                $total_quantity = $row['total_quantity'];

                $sql = "UPDATE tbl_product SET total_quantity = '$total_quantity' WHERE product_id = '$product_id'";
                if ($conn->query($sql) === TRUE) {
                    // echo "Inventory updated successfully";
                } else {
                    echo "Error updating product quantity: " . $conn->error;
                    $response = array('status' => 'failed', 'data' => null);
                    sendJsonResponse($response);
                }
            }
        }
        // Set the order status to "fulfilled" in tbl_order
        $sql = "UPDATE tbl_order SET status = true WHERE order_id = '$orderid'";
        if ($conn->query($sql) === TRUE) {
            $response = array('status' => 'success', 'data' => null);
            sendJsonResponse($response);
        } else {
            echo "Error updating order status: " . $conn->error;
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }

    } else {
        echo "No products found for order";
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} else {
    // echo "Invalid request";
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

// Function to send a JSON response
function sendJsonResponse($response)
{
    header('Content-Type: application/json');
    echo json_encode($response);
}