# Fichier app/index.php
@'
<?php
session_start();

if (!isset($_SESSION['attempts'])) {
    $_SESSION['attempts'] = 0;
    $_SESSION['last_attempt'] = time();
}

function checkBruteForce() {
    if ($_SESSION['attempts'] >= 5) {
        if (time() - $_SESSION['last_attempt'] < 300) {
            return false;
        }
        $_SESSION['attempts'] = 0;
    }
    return true;
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!checkBruteForce()) {
        $error = 'Too many attempts. Wait 5 minutes.';
    } else {
        $username = $_POST['username'];
        $password = $_POST['password'];
        
        if ($username === 'admin' && $password === 'SecurePass123') {
            $_SESSION['attempts'] = 0;
            $_SESSION['user'] = $username;
            header('Location: dashboard.php');
            exit;
        } else {
            $_SESSION['attempts']++;
            $_SESSION['last_attempt'] = time();
            $error = 'Invalid credentials';
        }
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Secure Login</title>
    <style>
        body { font-family: Arial; margin: 50px; }
        .login { max-width: 300px; margin: auto; padding: 20px; border: 1px solid #ccc; }
        input { width: 100%; padding: 8px; margin: 5px 0; }
        button { width: 100%; padding: 10px; background: green; color: white; border: none; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="login">
        <h2>Secure Login</h2>
        <?php if($error): ?>
            <div class="error"><?php echo $error; ?></div>
        <?php endif; ?>
        <form method="POST">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <p>Test: admin / SecurePass123</p>
    </div>
</body>
</html>
'@ | Out-File -FilePath app\index.php -Encoding UTF8