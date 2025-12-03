Param (
    #период в днях старше которого файл считается пригодным к удалению
    [int]$Period = 14 , 
    #каталог для просмотра  
    [String]$PATH = "\\Адрес сетевой папки\Папка где лежат бэкапы\" ,    
    #включать ли вложенные каталоги
    [bool]$recurse = $true
)


filter Get-OldFiles {
    Param (
        [int]$Period = 10
    )
    if (   
    ([DateTime]::Now.Subtract($_.CreationTime)).Days -gt $Period
    ) 
    { return $_ }
}
if ($recurse) 
{ dir -path $PATH -recurse  | Get-OldFiles -Period $Period | Remove-Item -recurse -force }
else
{ dir -path $PATH | Get-OldFiles -Period $Period | Remove-Item -force }

