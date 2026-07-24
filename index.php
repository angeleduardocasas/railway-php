<?php
// Mostrar errores para debug (solo temporal)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

echo "<h1>Prueba de conexión</h1>";

// Obtener variables de entorno
$host = getenv("MYSQLHOST");
$db   = getenv("MYSQLDATABASE");
$user = getenv("MYSQLUSER");
$pass = getenv("MYSQLPASSWORD");
$port = getenv("MYSQLPORT") ?: 3306;

echo "<h3>Variables de entorno:</h3>";
echo "<pre>";
echo "MYSQLHOST: " . ($host ?: "NO DEFINIDA") . "\n";
echo "MYSQLPORT: " . $port . "\n";
echo "MYSQLDATABASE: " . ($db ?: "NO DEFINIDA") . "\n";
echo "MYSQLUSER: " . ($user ?: "NO DEFINIDA") . "\n";
echo "MYSQLPASSWORD: " . ($pass ? "*** DEFINIDA ***" : "NO DEFINIDA") . "\n";
echo "</pre>";

// Verificar si las variables están definidas
if (!$host || !$db || !$user) {
    echo "<h2 style='color:orange'>⚠️ Variables de entorno de MySQL no configuradas</h2>";
    echo "<p>Por favor, configura las variables de entorno en Railway:</p>";
    echo "<ul>
            <li>MYSQLHOST</li>
            <li>MYSQLPORT</li>
            <li>MYSQLDATABASE</li>
            <li>MYSQLUSER</li>
            <li>MYSQLPASSWORD</li>
          </ul>";
    // Mostrar phpinfo para debug
    phpinfo();
    exit;
}

try {
    echo "<h3>Intentando conectar a MySQL...</h3>";
    
    $pdo = new PDO(
        "mysql:host=$host;port=$port;dbname=$db;charset=utf8mb4",
        $user,
        $pass,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
    
    echo "<h2 style='color:green'>✅ Conectado correctamente a MySQL</h2>";
    
    // Intentar consultar la tabla personas
    try {
        $sql = $pdo->query("SELECT * FROM personas");
        
        if ($sql && $sql->rowCount() > 0) {
            echo "<h3>Datos de la tabla personas:</h3>";
            echo "<table border='1' style='border-collapse: collapse; padding: 5px;'>";
            echo "<tr style='background: #ddd;'>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Edad</th>
                  </tr>";
            
            while($fila = $sql->fetch()) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars($fila["id"]) . "</td>";
                echo "<td>" . htmlspecialchars($fila["nombre"]) . "</td>";
                echo "<td>" . htmlspecialchars($fila["edad"]) . "</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p style='color:orange'>⚠️ La tabla 'personas' está vacía o no existe</p>";
        }
    } catch(PDOException $e) {
        echo "<h3 style='color:orange'>⚠️ Error al consultar tabla 'personas':</h3>";
        echo "<p>" . $e->getMessage() . "</p>";
        echo "<p>Es posible que la tabla no exista. Crea la tabla con:</p>";
        echo "<pre style='background: #f4f4f4; padding: 10px;'>
CREATE TABLE personas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    edad INT
);
        </pre>";
    }
    
} catch(PDOException $e) {
    echo "<h2 style='color:red'>❌ Error de conexión a MySQL:</h2>";
    echo "<p><strong>Mensaje:</strong> " . $e->getMessage() . "</p>";
    echo "<p><strong>Código:</strong> " . $e->getCode() . "</p>";
    
    // Mostrar información de ayuda
    echo "<h3>Posibles causas:</h3>";
    echo "<ul>
            <li>El host '$host' no es accesible</li>
            <li>El usuario '$user' no tiene permisos</li>
            <li>La contraseña es incorrecta</li>
            <li>La base de datos '$db' no existe</li>
          </ul>";
    
    // Mostrar phpinfo para debug
    phpinfo();
}
?>