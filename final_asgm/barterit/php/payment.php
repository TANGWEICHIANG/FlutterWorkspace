<?php
// Replace these with your PayPal sandbox credentials
$client_id = 'AWOR8ZHSzHy70M-Qm5Gxhv1YhXM7OKV889i0H-Dr4EunY--sAmLQeQzIVwvAfz8DZ13AJ3nq0N_FdIF-';
$client_secret = 'AWOR8ZHSzHy70M-Qm5Gxhv1YhXM7OKV889i0H-Dr4EunY--sAmLQeQzIVwvAfz8DZ13AJ3nq0N_FdIF-';

$email = $_GET['email']; // email
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$userid = $_GET['userid'];
$amount = $_GET['amount']; 

// Set up PayPal API endpoint
$api_endpoint = 'sb-y6tk026154053_api1.business.example.com';

// Set up request headers
$headers = array(
    'Content-Type: application/json',
);

// Set up request data
$data = array(
    'intent' => 'CAPTURE',
    'purchase_units' => array(
        array(
            'amount' => array(
                'currency_code' => 'MYR',
                'value' => $amount,
            ),
        ),
    ),
    'application_context' => array(
        'return_url' => "https://slumberjer.com/mynelayan/php/payment_update.php?userid=$userid&email=$email&phone=$phone&amount=$amount&name=$name",
        'cancel_url' => "https://slumberjer.com/mynelayan/cancel_url",
    ),
);

// Initialize cURL session
$ch = curl_init($api_endpoint);

// Set cURL options
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
curl_setopt($ch, CURLOPT_USERPWD, $client_id . ":" . $client_secret);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

// Execute cURL session and get the response
$response = curl_exec($ch);

// Check for cURL errors
if (curl_errno($ch)) {
    echo 'cURL error: ' . curl_error($ch);
    exit;
}

// Close cURL session
curl_close($ch);

// Decode the response JSON
$order = json_decode($response, true);

// Redirect the user to PayPal payment page
if (isset($order['links'])) {
    foreach ($order['links'] as $link) {
        if ($link['rel'] == 'approve') {
            header("Location: " . $link['href']);
            exit;
        }
    }
}

// If the redirect link is not found, display an error message
echo 'Error: PayPal link not found.';
?>
