<?php
include_once("dbconnect.php");
require_once('phpqrcode/qrlib.php');
require_once('fpdf/fpdf.php');

if (isset($_GET['order_id'])) {
    $order_id = $_GET['order_id'];

    // Retrieve order details
    $sql = "SELECT tbl_order.*, tbl_customer.* FROM tbl_order INNER JOIN tbl_customer ON tbl_order.cus_id = tbl_customer.cus_id WHERE tbl_order.order_id = '$order_id' AND tbl_order.status = '1'";
    $order_result = $conn->query($sql);
    $order_row = $order_result->fetch_assoc();
    $customer_name = $order_row['cus_name'];
    $customer_email = $order_row['cus_email'];
    $customer_address = $order_row['cus_address'];

    // Retrieve product details
    $sql = "SELECT order_product.*, tbl_product.*, tbl_inventory.*
    FROM order_product
    INNER JOIN tbl_order ON tbl_order.order_id = order_product.order_id
    INNER JOIN tbl_product ON tbl_product.product_id = order_product.product_id
    INNER JOIN tbl_inventory ON tbl_inventory.product_id = order_product.product_id
    WHERE order_product.order_id = $order_id AND tbl_inventory.batch_id = order_product.batch_number;";
    $product_result = $conn->query($sql);

    // Concatenate product details into a string
    $product_details = "";
    while ($product_row = $product_result->fetch_assoc()) {
        $product_name = $product_row['product_name'];
        $date_of_production = $product_row['date_of_production'];
        $shelf_life = $product_row['shelf_life'];
        $batch_num = $product_row['batch_num'];
        $best_before_date = $product_row['date_best_before'];
        $product_details .= "Product Name: $product_name\nDate of Production: $date_of_production \nShelf Life: $shelf_life \nBatch Number: $batch_num \nBest Before Date: $best_before_date\n\n";
    }

    // Generate QR code
    $text = "Customer Name: $customer_name\nCustomer Email: $customer_email\nManufacture: CropChain Sdn. Bhd. \nLocation: https://goo.gl/maps/Coq6xFfycsVA43f7A \n\n" . $product_details;
    $filename = $order_id.'.png';
    QRcode::png($text, $filename);

    // Generate PDF
    class PDF extends FPDF
    {
        function Header()
        {
            // Arial bold 15
            $this->SetFont('Arial', 'B', 15);

            // Move to the right
            $this->Cell(80);

            // Title
            $this->Cell(30, 10, 'Order Invoice', 0, 0, 'C');

            // Line break
            $this->Ln(20);
        }

        function Footer()
        {
            // Position at 1.5 cm from bottom
            $this->SetY(-15);

            // Arial italic 8
            $this->SetFont('Arial', 'I', 8);

            // Page number
            $this->Cell(0, 10, 'Page ' . $this->PageNo() . '/{nb}', 0, 0, 'C');
        }
    }

    $pdf = new PDF();
    $pdf->AliasNbPages();
    $pdf->AddPage();
    $pdf->SetFont('Arial', '', 12);

    // Write customer details
    $pdf->Cell(0, 10, 'Dear ' . $customer_name . ',', 0, 1);
    $pdf->Ln();
    $pdf->Cell(0, 10, 'Thank you for your order. Please find the details of your order below:', 0, 1);

    // Write order details
    $pdf->Cell(0, 10, 'Order ID: ' . $order_id, 0, 1);
    $pdf->Cell(0, 10, 'Customer Name: ' . $customer_name, 0, 1);
    $pdf->Cell(0, 10, 'Customer Email: ' . $customer_email, 0, 1);
    $pdf->Cell(0, 10, 'Customer Address: ' . $customer_address, 0, 1);
    $pdf->Ln();

    // Insert QR code
    $pdf->Cell(0, 10, 'Scan the QR code below to view the product details:', 0, 1);
    $pdf->Image($filename, 80, 120, 40, 40, 'PNG');

    // Add space
    $pdf->Ln();
    $pdf->Ln();
    $pdf->Ln();
    $pdf->Ln();
    $pdf->Ln();
     // Write closing message
     $pdf->Cell(0, 10, 'Best regards,', 0, 1);
     $pdf->Cell(0, 10, 'The CropChain Team', 0, 1);
    // Output PDF
    $pdf->Output();
} else {
    echo "Invalid Order ID.";
}
?>