Param (
    # Период в днях старше которого файл считается пригодным к удалению
    [int]$Period = 14,
    # Каталог для просмотра  
    [String]$PATH = "\\10.0.17.44\Trassir-BackUp\",     
   
    [bool]$recurse = $true
)

# Путь к файлу логов
$logFile = "W:\Skripts\logs\logfiles\logfile_rotation_Trassir$(Get-Date -Format 'dd-MM-yyyy').txt"

# Фильтр для получения старых файлов
filter Get-OldFiles {
    Param (
        [int]$Period = 10
    )
    if (([DateTime]::Now.Subtract($_.CreationTime)).Days -gt $Period) {
        return $_
    }
}

# Начинаем логировать
Add-Content -Path $logFile -Value "[$(Get-Date)] Запуск скрипта для удаления файлов старше $Period дней из каталога $PATH."

try {
    if ($recurse) {
        $filesToRemove = dir -path $PATH -recurse | Get-OldFiles -Period $Period
        Add-Content -Path $logFile -Value "[$(Get-Date)] Найдено файлов для удаления: $($filesToRemove.Count)."
        $filesToRemove | Remove-Item -recurse -force
    } else {
        $filesToRemove = dir -path $PATH | Get-OldFiles -Period $Period
        Add-Content -Path $logFile -Value "[$(Get-Date)] Найдено файлов для удаления: $($filesToRemove.Count)."
        $filesToRemove | Remove-Item -force
    }
    Add-Content -Path $logFile -Value "[$(Get-Date)] Удаление файлов завершено успешно."
} catch {
    Add-Content -Path $logFile -Value "[$(Get-Date)] Ошибка при удалении файлов: $_"
}

Add-Content -Path $logFile -Value "[$(Get-Date)] Скрипт завершен."
