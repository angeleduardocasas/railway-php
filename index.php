<?php

$host = getenv("MYSQLHOST");
$db   = getenv("MYSQLDATABASE");
$user = getenv("MYSQLUSER");
$pass = getenv("MYSQLPASSWORD");
$port = getenv("MYSQLPORT");

try{

$pdo = new PDO(
"mysql:host=$host;port=$port;dbname=$db",
$user,
$pass
);

echo "<h2>Conectado correctamente</h2>";

$sql = $pdo->query("SELECT * FROM personas");

echo "<table border='1'>";

echo "<tr>
<th>ID</th>
<th>Nombre</th>
<th>Edad</th>
</tr>";

while($fila=$sql->fetch()){

echo "<tr>";

echo "<td>".$fila["id"]."</td>";

echo "<td>".$fila["nombre"]."</td>";

echo "<td>".$fila["edad"]."</td>";

echo "</tr>";

}

echo "</table>";

}catch(PDOException $e){

echo $e->getMessage();

}

?>