param(
    [ValidateSet("1", "2", "3", "")]
    [string]$Modo = "",
    [string]$Mensagem = "",
    [string]$RemoteUrl = ""
)

$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot

function Gerar-Rar {
    $rarExe = "C:\Program Files\WinRAR\Rar.exe"
    if (-not (Test-Path $rarExe)) {
        Write-Host "WinRAR (Rar.exe) não encontrado em $rarExe" -ForegroundColor Red
        return
    }

    $arquivoRar = "trabalho-restaurante.rar"
    if (Test-Path $arquivoRar) {
        Remove-Item $arquivoRar -Force
    }

    & $rarExe a -r -y `
        "-x*\node_modules" "-x*\node_modules\*" `
        "-x.git" "-x.git\*" `
        "-x*.rar" "-x*.db" "-xenviar.ps1" `
        $arquivoRar "." | Out-Null

    if ($LASTEXITCODE -eq 0 -and (Test-Path $arquivoRar)) {
        $tamanhoKB = [math]::Round((Get-Item $arquivoRar).Length / 1KB, 1)
        Write-Host "Arquivo gerado: $PSScriptRoot\$arquivoRar ($tamanhoKB KB)" -ForegroundColor Green
    } else {
        Write-Host "Erro ao gerar arquivo .rar (código $LASTEXITCODE)." -ForegroundColor Red
    }
}

function Enviar-Git {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "Git não encontrado no sistema." -ForegroundColor Red
        return
    }

    if (-not (Test-Path ".git")) {
        git init -b main
    }

    git add -A
    $pendente = git status --porcelain

    if ($pendente) {
        if (-not $Mensagem) {
            $Mensagem = Read-Host "Mensagem do commit (Enter para 'Atualiza trabalho restaurante')"
            if (-not $Mensagem) { $Mensagem = "Atualiza trabalho restaurante" }
        }
        git commit -m $Mensagem
    } else {
        Write-Host "Nenhuma alteração nova para commit." -ForegroundColor Yellow
    }

    $origin = ""
    try {
        $origin = (git remote get-url origin 2>$null)
    } catch {
        $origin = ""
    }

    if (-not $origin) {
        if (-not $RemoteUrl) {
            $RemoteUrl = Read-Host "Cole a URL do repositório Git (ou Enter para pular o push)"
        }
        if ($RemoteUrl) {
            git remote add origin $RemoteUrl
            $origin = $RemoteUrl
        }
    }

    if ($origin) {
        git push -u origin HEAD
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Enviado para o Git com sucesso ($origin)." -ForegroundColor Green
        }
    } else {
        Write-Host "Commit salvo localmente. Configure o remote 'origin' depois para fazer o push." -ForegroundColor Yellow
    }
}

try {
    if (-not $Modo) {
        Write-Host "O que deseja fazer?"
        Write-Host "1 - Gerar arquivo .rar"
        Write-Host "2 - Enviar para o Git"
        Write-Host "3 - Fazer os dois"
        $Modo = Read-Host "Escolha (1, 2 ou 3) [3]"
        if (-not $Modo) { $Modo = "3" }
    }

    if ($Modo -eq "1" -or $Modo -eq "3") {
        Gerar-Rar
    }
    if ($Modo -eq "2" -or $Modo -eq "3") {
        Enviar-Git
    }
} finally {
    Pop-Location
}
