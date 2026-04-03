# Fichier app/logout.php
@'
<?php
session_start();
session_destroy();
header('Location: index.php');
exit;
?>
'@ | Out-File -FilePath app\logout.php -Encoding UTF8