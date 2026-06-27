<?php
header('Content-Type: application/json; charset=UTF-8');
header('Access-Control-Allow-Origin: https://franvela.com');
header('Access-Control-Allow-Methods: POST');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

$to      = 'franciscojavier.velaterrero@gmail.com';
$name    = trim(strip_tags($_POST['nombre'] ?? $_POST['name'] ?? ''));
$email   = trim(filter_var($_POST['email'] ?? '', FILTER_SANITIZE_EMAIL));
$subject = trim(strip_tags($_POST['asunto'] ?? $_POST['subject'] ?? ''));
$message = trim(strip_tags($_POST['mensaje'] ?? $_POST['message'] ?? ''));
$bot     = $_POST['bot-field'] ?? '';

// Honeypot anti-spam
if ($bot !== '') {
    http_response_code(200);
    echo json_encode(['success' => true]);
    exit;
}

// Validación
if (!$name || !$email || !$subject || !$message) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Campos requeridos vacíos']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Email inválido']);
    exit;
}

$email_subject = '[franvela.com] ' . $subject;
$email_body    = "Nombre: $name\nEmail: $email\n\nMensaje:\n$message";
$headers       = implode("\r\n", [
    "From: franvela.com <noreply@franvela.com>",
    "Reply-To: $name <$email>",
    "MIME-Version: 1.0",
    "Content-Type: text/plain; charset=UTF-8",
    "Content-Transfer-Encoding: 8bit",
    "X-Mailer: PHP/" . phpversion(),
]);

if (mail($to, $email_subject, $email_body, $headers)) {
    echo json_encode(['success' => true]);
} else {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error al enviar']);
}
