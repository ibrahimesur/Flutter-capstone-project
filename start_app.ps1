# Flutter Sağlık Uygulaması Başlatma Scripti

# Hata işleme
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue" # İşlem çubuklarını devre dışı bırak

# Zamanı ölç ve logla
$startTime = Get-Date
Write-Host "[$(Get-Date -Format 'HH:mm:ss')] ======= Flutter Sağlık Uygulaması Başlatılıyor =======" -ForegroundColor Magenta
Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Çalışma dizini: $PSScriptRoot" -ForegroundColor Gray

# Bilgisayar hakkında bilgileri göster
$computerInfo = Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer
Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Windows Sürümü: $($computerInfo.WindowsProductName) $($computerInfo.WindowsVersion)" -ForegroundColor Gray

# Ağ bilgilerini göster
$ipv4Addresses = Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4" -and $_.InterfaceAlias -notlike "*Loopback*"}
Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Ağ bilgileri:" -ForegroundColor Gray
foreach ($ip in $ipv4Addresses) {
    Write-Host "  - $($ip.InterfaceAlias): $($ip.IPAddress)" -ForegroundColor Gray
}

# Fonksiyonların tanımlanması
function Start-FlaskBackend {
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Backend başlatılıyor..." -ForegroundColor Cyan
    $backendPath = Join-Path -Path $PSScriptRoot -ChildPath "backend"
    
    # Backend klasörünün varlığını kontrol et
    if (-not (Test-Path $backendPath)) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] HATA: Backend klasörü bulunamadı: $backendPath" -ForegroundColor Red
        return $false
    }

    # Veri seti klasörünün varlığını kontrol et
    $datasetPath = Join-Path -Path $PSScriptRoot -ChildPath "Datasets"
    if (-not (Test-Path $datasetPath)) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] UYARI: Datasets klasörü bulunamadı: $datasetPath" -ForegroundColor Yellow
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Datasets klasörü oluşturuluyor..." -ForegroundColor Yellow
        New-Item -Path $datasetPath -ItemType Directory | Out-Null
    }

    # Dataset dosyasının varlığını kontrol et
    $datasetFile = Join-Path -Path $datasetPath -ChildPath "Disease and symptoms dataset.csv"
    if (-not (Test-Path $datasetFile)) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] UYARI: Veri seti dosyası bulunamadı: $datasetFile" -ForegroundColor Yellow
        # İleride veri seti indirme kodu eklenebilir
    }
    
    # Python yüklü mü kontrol et
    try {
        $pythonVersion = & python --version 2>&1
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Python sürümü: $pythonVersion" -ForegroundColor Gray
    }
    catch {
        try {
            $pythonVersion = & python3 --version 2>&1
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Python sürümü: $pythonVersion" -ForegroundColor Gray
            $pythonCmd = "python3"
        }
        catch {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] HATA: Python yüklü değil! Lütfen Python'u yükleyin ve PATH'e ekleyin." -ForegroundColor Red
            return $false
        }
    }
    
    # Gerekli paketlerin yüklenmesini kontrol et
    try {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Python paketleri kontrol ediliyor..." -ForegroundColor Yellow
        $requirementsPath = Join-Path -Path $backendPath -ChildPath "requirements.txt"
        
        if (-not (Test-Path $requirementsPath)) {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] UYARI: requirements.txt dosyası bulunamadı, ana dizindeki dosya kullanılacak" -ForegroundColor Yellow
            $requirementsPath = Join-Path -Path $PSScriptRoot -ChildPath "requirements.txt"
        }
        
        $pythonCmd = if (Get-Command python -ErrorAction SilentlyContinue) { "python" } elseif (Get-Command python3 -ErrorAction SilentlyContinue) { "python3" } else { throw "Python bulunamadı" }
        
        # Python paketlerini kur
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Gerekli Python paketleri kuruluyor..." -ForegroundColor Yellow
        & $pythonCmd -m pip install -r $requirementsPath
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] UYARI: Bazı paketler yüklenemedi, tekrar deneniyor..." -ForegroundColor Yellow
            & $pythonCmd -m pip install flask pandas flask-cors
        }
        
        # Flask API'yi başlat (ayrı bir pencerede)
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Flask API başlatılıyor..." -ForegroundColor Green
        
        # Windows güvenlik duvarı için port 8000'i açmayı dene
        try {
            if (-not (Get-NetFirewallRule -DisplayName "Flask API 8000" -ErrorAction SilentlyContinue)) {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Windows güvenlik duvarında port 8000 açılıyor..." -ForegroundColor Yellow
                New-NetFirewallRule -DisplayName "Flask API 8000" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000 -ErrorAction SilentlyContinue | Out-Null
            }
        } catch {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] UYARI: Güvenlik duvarı kuralı oluşturulamadı. Yönetici yetkileri gerekebilir." -ForegroundColor Yellow
        }
        
        # Arka planda veya yeni pencerede çalıştır
        $appPath = Join-Path -Path $backendPath -ChildPath "app.py"
        if (-not (Test-Path $appPath)) {
            $appPath = Join-Path -Path $PSScriptRoot -ChildPath "app.py"
            if (-not (Test-Path $appPath)) {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] HATA: app.py dosyası bulunamadı!" -ForegroundColor Red
                return $false
            }
            # app.py dosyası ana dizindeyse, backend dizinine kopyala
            Copy-Item -Path $appPath -Destination $backendPath -Force
            $appPath = Join-Path -Path $backendPath -ChildPath "app.py"
        }
        
        # Server'ı başlat (yeni pencere)
        Start-Process PowerShell -ArgumentList "-NoExit", "-Command", "Set-Location '$backendPath'; & $pythonCmd '$appPath'; Read-Host 'Çıkmak için Enter tuşuna basın...'" -WindowStyle Normal
        
        # Backend'in başlamasını bekle
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Backend başlama bekleniyor (5 saniye)..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        
        # Bağlantıyı test et
        try {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] API bağlantısı test ediliyor..." -ForegroundColor Yellow
            $testResult = Invoke-WebRequest -Uri "http://localhost:8000/" -TimeoutSec 5 -ErrorAction SilentlyContinue
            if ($testResult.StatusCode -eq 200) {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Backend başarıyla başlatıldı! Durum: $($testResult.StatusCode)" -ForegroundColor Green
                return $true
            }
        } catch {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] UYARI: Backend yanıt vermiyor, ancak başlatılmış olabilir. İşleme devam ediliyor..." -ForegroundColor Yellow
            return $true # Yine de devam et
        }
        
        return $true
    }
    catch {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] HATA: Backend başlatılamadı: $_" -ForegroundColor Red
        return $false
    }
}

function Start-FlutterWeb {
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Flutter Web uygulaması başlatılıyor..." -ForegroundColor Cyan
    
    # Flutter'ın yüklü olduğunu kontrol et
    try {
        $flutterVersion = & flutter --version 2>&1
        $flutterVersionLine = $flutterVersion -split "`n" | Select-Object -First 1
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Flutter sürümü: $flutterVersionLine" -ForegroundColor Gray
    }
    catch {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] HATA: Flutter yüklü değil veya PATH'de bulunamadı." -ForegroundColor Red
        return $false
    }
    
    # Flutter paketlerini yükle
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Flutter paketleri yükleniyor..." -ForegroundColor Yellow
    & flutter pub get
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] UYARI: Flutter paketleri yüklenirken hata oluştu, tekrar deneniyor..." -ForegroundColor Yellow
        & flutter clean
        & flutter pub get
    }
    
    # Flutter Web için Chrome kullanılabilir mi?
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Chrome tarayıcı kontrolü yapılıyor..." -ForegroundColor Yellow
    $devices = & flutter devices 2>&1
    
    $chromeAvailable = $devices -match "chrome"
    
    if (-not $chromeAvailable) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] UYARI: Chrome tarayıcı tespit edilemedi. Web için Chrome gereklidir." -ForegroundColor Yellow
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Chrome otomatik kurulum deneniyor..." -ForegroundColor Yellow
        & flutter config --enable-web
    }
    
    # Uygulamayı başlat
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Flutter Web uygulaması başlatılıyor (--web-hostname seçeneği ile)..." -ForegroundColor Green
    
    # Farklı host ve port seçenekleriyle başlatmayı dene
    Start-Process PowerShell -ArgumentList "-NoExit", "-Command", "Set-Location '$PSScriptRoot'; flutter run -d chrome --web-hostname=0.0.0.0 --web-port=8080; Read-Host 'Çıkmak için Enter tuşuna basın...'" -WindowStyle Normal
    
    return $true
}

# Ana işlemleri çalıştır
$backendStarted = Start-FlaskBackend
if ($backendStarted) {
    $flutterStarted = Start-FlutterWeb
    
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] === Uygulama Bilgileri ===" -ForegroundColor Magenta
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Backend API: http://localhost:8000/" -ForegroundColor Green
    
    if ($flutterStarted) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Flutter Web: http://localhost:8080/" -ForegroundColor Green
    } else {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Flutter Web başlatılamadı." -ForegroundColor Red
    }
    
    # Bağlantı bilgisini göster
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] === Bağlantı Bilgileri ===" -ForegroundColor Magenta
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Eğer uygulamada bağlantı sorunu yaşarsanız, aşağıdaki IP'leri manuel olarak Flutter kodu içerisinde deneyebilirsiniz:" -ForegroundColor Yellow
    foreach ($ip in $ipv4Addresses) {
        Write-Host "  SemptomService.addLocalNetworkIp('$($ip.IPAddress)');" -ForegroundColor Yellow
    }
    
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] ======= İşlem Tamamlandı =======" -ForegroundColor Magenta
    $endTime = Get-Date
    $duration = $endTime - $startTime
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Toplam süre: $($duration.Minutes) dakika $($duration.Seconds) saniye" -ForegroundColor Gray
}
else {
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Flask backend başlatılamadı, Flutter uygulaması başlatılmıyor." -ForegroundColor Red
} 