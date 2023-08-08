# Configuration de l'API DNA
$APIURL = "https://api.example.com/dna"
$Headers = @{
    "Authorization" = "Bearer YOUR_API_TOKEN" # Remplacez YOUR_API_TOKEN par le token d'authentification réel
}

# Configuration de la connexion à la base de données SQL Server
$DBServer = "your_server"
$DBName = "your_database"
$DBUser = "your_username"
$DBPassword = "your_password"

function Fetch-Data-From-DNA-API {
    try {
        $response = Invoke-RestMethod -Uri $APIURL -Headers $Headers

        if ($response -ne $null) {
            return $response
        } else {
            Write-Host "La requête API a échoué avec le code d'état: $($response.StatusCode)" -ForegroundColor Red
            return $null
        }
    } catch {
        Write-Host "La requête API a échoué avec l'erreur: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Save-Data-To-SQL-Server {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$Data
    )

    try {
        $connStr = "Server=$DBServer;Database=$DBName;User Id=$DBUser;Password=$DBPassword;"
        $query = "INSERT INTO your_table (column1, column2) VALUES (@col1, @col2)"

        $conn = New-Object System.Data.SqlClient.SqlConnection
        $conn.ConnectionString = $connStr
        $conn.Open()

        $cmd = $conn.CreateCommand()

        foreach ($item in $Data) {
            # Remplacez 'key1' et 'key2' par les clés réelles présentes dans les données JSON de l'API
            $col1_value = $item.key1
            $col2_value = $item.key2

            $cmd.CommandText = $query
            $cmd.Parameters.AddWithValue("@col1", $col1_value)
            $cmd.Parameters.AddWithValue("@col2", $col2_value)
            $cmd.ExecuteNonQuery()
        }

        $conn.Close()

        Write-Host "Données enregistrées dans SQL Server avec succès." -ForegroundColor Green
    } catch {
        Write-Host "Erreur lors de l'enregistrement des données dans SQL Server: $_" -ForegroundColor Red
    }
}

if ($PSVersionTable.PSVersion.Major -lt 6) {
    Write-Host "Ce script nécessite PowerShell 6.0 ou supérieur pour utiliser Invoke-RestMethod." -ForegroundColor Red
    exit
}

# Exécutez les fonctions pour récupérer les données de l'API et les enregistrer dans SQL Server
$apiData = Fetch-Data-From-DNA-API

if ($apiData -ne $null) {
    Save-Data-To-SQL-Server -Data $apiData
}