<?php
include_once("dbconnect.php");

if (isset($_GET['order_id'])) {
    $order_id = $_GET['order_id'];

    // create an empty array to store the data
    $data = array();

    // join three tables
    $sql = "SELECT tbl_customer.*, tbl_order.*, order_product.*, tbl_product.*
        FROM tbl_order
        INNER JOIN tbl_customer ON tbl_order.cus_id = tbl_customer.cus_id
        INNER JOIN order_product ON tbl_order.order_id = order_product.order_id
        INNER JOIN tbl_product ON order_product.product_id = tbl_product.product_id
        WHERE order_product.order_id = $order_id";

    // execute query
    $result = mysqli_query($conn, $sql);

    // check if any results were returned
    if (mysqli_num_rows($result) > 0) {
        // output data of each row
        while ($row = mysqli_fetch_assoc($result)) {
            // access the columns by their respective table names
            $cus_id = $row['cus_id'];
            $cus_name = $row['cus_name'];
            $cus_email = $row['cus_email'];
            $cus_address = $row['cus_address'];
            $cus_phone = $row['cus_phone'];
            $order_id = $row['order_id'];
            $date_order = $row['date_order'];
            $total_price = $row['total_price'];
            $quantity_buy = $row['quantity_buy'];
            $product_name = $row['product_name'];
            $price = $row['price'];
            $status = $row['status'] === "1" ? true : false; // use lowercase true and false

            // add the retrieved data to the array
            $data[] = array(
                "cus_id" => $cus_id,
                "cus_name" => $cus_name,
                "cus_email" => $cus_email,
                "cus_address" => $cus_address,
                "cus_phone" => $cus_phone,
                "order_id" => $order_id,
                "date_order" => $date_order,
                "total_price" => $total_price,
                "quantity_buy" => $quantity_buy,
                "product_name" => $product_name,
                "price" => $price,
                "status" => $status,
            );
        }
    } else {
        echo "0 results";
    }

    // close the database connection
    mysqli_close($conn);

    // send JSON response
    header('Content-Type: application/json');
    echo json_encode($data);
}
?>