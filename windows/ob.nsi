;Enable Unicode encoding
;Unicode True

;Include Modern UI
!include "MUI2.nsh"
!include "FileFunc.nsh"

!addplugindir "$%AppData%"

; ------------------- ;
;      Settings       ;
; ------------------- ;
!define APP_NAME "OpenBazaar"
!define PT_VERSION "1.0.0"
!define APP_URL "https://www.openbazaar.org"

Name "${APP_NAME}"
Caption "${APP_NAME} ${PT_VERSION}"
BrandingText "${APP_NAME} ${PT_VERSION}"

CRCCheck on
SetCompressor /SOLID lzma
OutFile "OpenBazaar_Setup.exe"

;Default installation folder
InstallDir "$LOCALAPPDATA\${APP_NAME}"

;Request application privileges
RequestExecutionLevel admin

!define APP_LAUNCHER "OpenBazaar.exe"
!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

; ------------------- ;
;     UI Settings     ;
; ------------------- ;
;Define UI settings

;!define MUI_UI_HEADERIMAGE_RIGHT "../../src/app/images/icon.png"
!define MUI_ICON "systray.ico"
!define MUI_UNICON "systray.ico"

!define MUI_WELCOMEFINISHPAGE_BITMAP "OpenBazaar_Windows_Installer.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "OpenBazaar_Windows_Installer.bmp"
!define MUI_ABORTWARNING
;!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_LINK "${APP_URL}"
!define MUI_FINISHPAGE_LINK_LOCATION "${APP_URL}"
!define MUI_FINISHPAGE_RUN "Powershell.exe"
!define MUI_FINISHPAGE_RUN_PARAMETERS "-ExecutionPolicy ByPass -File $INSTDIR\OpenBazaar.ps1"
!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_TEXT "$(desktopShortcut)"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION finishpageaction

;Define the pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;Define uninstall pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;Load Language Files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Afrikaans"
!insertmacro MUI_LANGUAGE "Albanian"
!insertmacro MUI_LANGUAGE "Arabic"
!insertmacro MUI_LANGUAGE "Belarusian"
!insertmacro MUI_LANGUAGE "Bosnian"
!insertmacro MUI_LANGUAGE "Bulgarian"
!insertmacro MUI_LANGUAGE "Catalan"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Czech"
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "Esperanto"
!insertmacro MUI_LANGUAGE "Estonian"
!insertmacro MUI_LANGUAGE "Farsi"
!insertmacro MUI_LANGUAGE "Finnish"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Galician"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Greek"
!insertmacro MUI_LANGUAGE "Hebrew"
!insertmacro MUI_LANGUAGE "Hungarian"
!insertmacro MUI_LANGUAGE "Icelandic"
!insertmacro MUI_LANGUAGE "Indonesian"
!insertmacro MUI_LANGUAGE "Irish"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "Latvian"
!insertmacro MUI_LANGUAGE "Lithuanian"
!insertmacro MUI_LANGUAGE "Macedonian"
!insertmacro MUI_LANGUAGE "Malay"
!insertmacro MUI_LANGUAGE "Mongolian"
!insertmacro MUI_LANGUAGE "Norwegian"
!insertmacro MUI_LANGUAGE "NorwegianNynorsk"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "Serbian"
!insertmacro MUI_LANGUAGE "SerbianLatin"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Slovak"
!insertmacro MUI_LANGUAGE "Slovenian"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "SpanishInternational"
!insertmacro MUI_LANGUAGE "Swedish"
!insertmacro MUI_LANGUAGE "Thai"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Turkish"
!insertmacro MUI_LANGUAGE "Ukrainian"
;!insertmacro MUI_LANGUAGE "Vietnamese"
!insertmacro MUI_LANGUAGE "Welsh"

; ------------------- ;
;    Localization     ;
; ------------------- ;
LangString removeDataFolder ${LANG_ENGLISH} "Remove all databases and configuration files?"
LangString removeDataFolder ${LANG_Afrikaans} "Alle databasisse en opset lêers verwyder?"
LangString removeDataFolder ${LANG_Albanian} "Hiq të gjitha bazat e të dhënave dhe fotografi konfigurimit?"
LangString removeDataFolder ${LANG_Arabic} "إزالة كافة قواعد البيانات وملفات التكوين؟"
LangString removeDataFolder ${LANG_Belarusian} "Выдаліць усе базы дадзеных і файлы канфігурацыі?"
LangString removeDataFolder ${LANG_Bosnian} "Uklonite sve baze podataka i konfiguracijske datoteke?"
LangString removeDataFolder ${LANG_Bulgarian} "Премахнете всички бази данни и конфигурационни файлове?"
LangString removeDataFolder ${LANG_Catalan} "Eliminar totes les bases de dades i arxius de configuració?"
LangString removeDataFolder ${LANG_Croatian} "Uklonite sve baze podataka i konfiguracijske datoteke?"
LangString removeDataFolder ${LANG_Czech} "Odstraňte všechny databáze a konfiguračních souborů?"
LangString removeDataFolder ${LANG_Danish} "Fjern alle databaser og konfigurationsfiler?"
LangString removeDataFolder ${LANG_Dutch} "Verwijder alle databases en configuratiebestanden?"
LangString removeDataFolder ${LANG_Esperanto} "Forigi la tuta datumbazojn kaj agordaj dosieroj?"
LangString removeDataFolder ${LANG_Estonian} "Eemalda kõik andmebaasid ja konfiguratsioonifailid?"
LangString removeDataFolder ${LANG_Farsi} "حذف تمام پایگاه داده ها و فایل های پیکربندی؟"
LangString removeDataFolder ${LANG_Finnish} "Poista kaikki tietokannat ja asetustiedostot?"
LangString removeDataFolder ${LANG_French} "Supprimer toutes les bases de données et les fichiers de configuration ?"
LangString removeDataFolder ${LANG_Galician} "Eliminar todos os bancos de datos e arquivos de configuración?"
LangString removeDataFolder ${LANG_German} "Alle Datenbanken und Konfigurationsdateien zu entfernen?"
LangString removeDataFolder ${LANG_Greek} "Αφαιρέστε όλες τις βάσεις δεδομένων και τα αρχεία διαμόρφωσης;"
LangString removeDataFolder ${LANG_Hebrew} "הסר את כל קבצי תצורת מסדי נתונים ו"
LangString removeDataFolder ${LANG_Hungarian} "Vegye ki az összes adatbázisok és konfigurációs fájlok?"
LangString removeDataFolder ${LANG_Icelandic} "Fjarlægja allar gagnagrunna og stillingar skrá?"
LangString removeDataFolder ${LANG_Indonesian} "Hapus semua database dan file konfigurasi?"
LangString removeDataFolder ${LANG_Irish} "Bain na bunachair shonraí agus comhaid cumraíochta?"
LangString removeDataFolder ${LANG_Italian} "Rimuovere tutti i database ei file di configurazione?"
LangString removeDataFolder ${LANG_Japanese} "すべてのデータベースと設定ファイルを削除しますか？"
LangString removeDataFolder ${LANG_Korean} "모든 데이터베이스와 구성 파일을 삭제 하시겠습니까?"
LangString removeDataFolder ${LANG_Latvian} "Noņemt visas datu bāzes un konfigurācijas failus?"
LangString removeDataFolder ${LANG_Lithuanian} "Pašalinti visas duombazes ir konfigūravimo failus?"
LangString removeDataFolder ${LANG_Macedonian} "Отстрани ги сите бази на податоци и конфигурациските датотеки?"
LangString removeDataFolder ${LANG_Malay} "Buang semua pangkalan data dan fail-fail konfigurasi?"
LangString removeDataFolder ${LANG_Mongolian} "Бүх өгөгдлийн сангууд болон тохиргооны файлуудыг устгана?"
LangString removeDataFolder ${LANG_Norwegian} "Fjern alle databaser og konfigurasjonsfiler?"
LangString removeDataFolder ${LANG_NorwegianNynorsk} "Fjern alle databaser og konfigurasjonsfiler?"
LangString removeDataFolder ${LANG_Polish} "Usuń wszystkie bazy danych i plików konfiguracyjnych?"
LangString removeDataFolder ${LANG_Portuguese} "Remova todos os bancos de dados e arquivos de configuração?"
LangString removeDataFolder ${LANG_PortugueseBR} "Remova todos os bancos de dados e arquivos de configuração?"
LangString removeDataFolder ${LANG_Romanian} "Elimina toate bazele de date și fișierele de configurare?"
LangString removeDataFolder ${LANG_Russian} "Удалить все базы данных и файлы конфигурации?"
LangString removeDataFolder ${LANG_Serbian} "Уклоните све базе података и конфигурационе фајлове?"
LangString removeDataFolder ${LANG_SerbianLatin} "Uklonite sve baze podataka i datoteke za konfiguraciju ?"
LangString removeDataFolder ${LANG_SimpChinese} "删除所有数据库和配置文件？"
LangString removeDataFolder ${LANG_Slovak} "Odstráňte všetky databázy a konfiguračných súborov?"
LangString removeDataFolder ${LANG_Slovenian} "Odstranite vse podatkovne baze in konfiguracijske datoteke?"
LangString removeDataFolder ${LANG_Spanish} "Eliminar todas las bases de datos y archivos de configuración?"
LangString removeDataFolder ${LANG_SpanishInternational} "Eliminar todas las bases de datos y archivos de configuración?"
LangString removeDataFolder ${LANG_Swedish} "Ta bort alla databaser och konfigurationsfiler?"
LangString removeDataFolder ${LANG_Thai} "ลบฐานข้อมูลทั้งหมดและแฟ้มการกำหนดค่า?"
LangString removeDataFolder ${LANG_TradChinese} "刪除所有數據庫和配置文件？"
LangString removeDataFolder ${LANG_Turkish} "Tüm veritabanlarını ve yapılandırma dosyaları çıkarın?"
LangString removeDataFolder ${LANG_Ukrainian} "Видалити всі бази даних і файли конфігурації?"
;LangString removeDataFolder ${LANG_Vietnamese} "Loại bỏ tất cả các cơ sở dữ liệu và các tập tin cấu hình?"
LangString removeDataFolder ${LANG_Welsh} "Tynnwch yr holl gronfeydd data a ffeiliau cyfluniad?"

LangString noRoot ${LANG_ENGLISH} "You cannot install OpenBazaar in a directory that requires administrator permissions"
LangString noRoot ${LANG_Afrikaans} "Jy kan nie OpenBazaar installeer in 'n gids wat administrateur regte vereis"
LangString noRoot ${LANG_Albanian} "Ju nuk mund të instaloni OpenBazaar në një directory që kërkon lejet e administratorit"
LangString noRoot ${LANG_Arabic} " لا يمكنك تثبيت OpenBazaar في مجلد يتطلب صلاحيات مدير"
LangString noRoot ${LANG_Belarusian} "Вы не можаце ўсталяваць OpenBazaar ў каталогу, які патрабуе правоў адміністратара"
LangString noRoot ${LANG_Bosnian} "Nemoguće instalirati OpenBazaar u direktorij koji zahtjeva administrativnu dozvolu"
LangString noRoot ${LANG_Bulgarian} "Не може да инсталирате OpenBazaar в директория, изискваща администраторски права"
LangString noRoot ${LANG_Catalan} "No es pot instal·lar OpenBazaar en un directori que requereix permisos d'administrador"
LangString noRoot ${LANG_Croatian} "Nemoguće instalirati OpenBazaar u mapi koja zahtjeva administrativnu dozvolu"
LangString noRoot ${LANG_Czech} "Nemůžete nainstalovat OpenBazaar do složky, která vyžaduje administrátorské oprávnění"
LangString noRoot ${LANG_Danish} "OpenBazaar kan ikke installeres til denne sti, da det kræver administratorrettigheder"
LangString noRoot ${LANG_Dutch} "OpenBazaar kan niet worden geïnstalleerd in een map die beheerdersrechten vereist"
LangString noRoot ${LANG_Esperanto} "Vi ne povas instali OpenBazaar en dosierujo kiu postulas administranto permesojn"
LangString noRoot ${LANG_Estonian} "OpenBazaar`i ei ole võimalik installida kataloogi mis nõuab administraatori õiguseid"
LangString noRoot ${LANG_Farsi} "در یک دایرکتوری که نیاز به مجوز مدیر نصب OpenBazaar  کنید شما می توانید "
LangString noRoot ${LANG_Finnish} "Et voi asentaa OpenBazaar hakemistossa, joka vaatii järjestelmänvalvojan oikeudet"
LangString noRoot ${LANG_French} "OpenBazaar ne peut être installé dans un répertoire nécessitant un accès administrateur"
LangString noRoot ${LANG_Galician} "OpenBazaar non se pode instalar nun directorio que requira permisos de administrador"
LangString noRoot ${LANG_German} "OpenBazaar kann nicht in einem Ordner installiert werden für den Administratorrechte benötigt werden"
LangString noRoot ${LANG_Greek} "Δεν μπορείτε να εγκαταστήσετε το OpenBazaar σε ένα φάκελο που απαιτεί δικαιώματα διαχειριστή"
LangString noRoot ${LANG_Hebrew} "אין באפשרותכם להתקין את OpenBazaar בתיקייה שדורשת הרשאות מנהל"
LangString noRoot ${LANG_Hungarian} "A OpenBazaar nem telepíthető olyan mappába, amely adminisztrátori hozzáférést igényel"
LangString noRoot ${LANG_Icelandic} "Þú getur ekki sett OpenBazaar í möppu sem þarfnast stjórnenda réttindi"
LangString noRoot ${LANG_Indonesian} "Anda tidak bisa menginstall OpenBazaar pada direktori yang memerlukan ijin dari Administrator"
LangString noRoot ${LANG_Irish} "Ní féidir leat a shuiteáil OpenBazaar i eolaire go n-éilíonn ceadanna riarthóir"
LangString noRoot ${LANG_Italian} "Non puoi installare OpenBazaar in una cartella che richiede i permessi d'amministratore"
LangString noRoot ${LANG_Japanese} "アドミニストレータの聴許が必要なディレクトリには 'OpenBazaar'をインストールできません。"
LangString noRoot ${LANG_Korean} "관리자 권한이 요구되는 위치에 OpenBazaar을 설치 할 수 없습니다"
LangString noRoot ${LANG_Latvian} "Jūs nevarat instalēt OpenBazaar direktorijā, kas prasa administratora atļaujas"
LangString noRoot ${LANG_Lithuanian} "Jūs negalite įdiegti OpenBazaar į katalogą, kad reikia administratoriaus teisių"
LangString noRoot ${LANG_Macedonian} "Не можете да инсталирате OpenBazaar во директориумот кој бара администраторски дозволи"
LangString noRoot ${LANG_Malay} "Anda tidak boleh memasang OpenBazaar dalam direktori yang memerlukan keizinan pentadbir"
LangString noRoot ${LANG_Mongolian} "Та администратор зөвшөөрөл шаарддаг сан дахь OpenBazaar суулгаж чадахгүй байгаа"
LangString noRoot ${LANG_Norwegian} "OpenBazaar kan ikke installeres i en mappe som krever administratorrettigheter"
LangString noRoot ${LANG_NorwegianNynorsk} "OpenBazaar kan ikke installeres i en mappe som krever administratorrettigheter"
LangString noRoot ${LANG_Polish} "Nie można zainstalować OpenBazaar w katalogu wymagającym uprawnień administratora"
LangString noRoot ${LANG_Portuguese} "Não é possível instalar o OpenBazaar numa pasta que requer permissões administrativas"
LangString noRoot ${LANG_PortugueseBR} "OpenBazaar não poderá ser instalado em um diretório que requer permissões de administrador"
LangString noRoot ${LANG_Romanian} "Nu puteți instala OpenBazaar într-un director care necesită permisiuni de administrator"
LangString noRoot ${LANG_Russian} "OpenBazaar не может быть установлена в директорию требующей полномочия Администратора"
LangString noRoot ${LANG_Serbian} "Ви не можете инсталирати ПопцорнТиме у директоријуму која захтева администраторске дозволе"
LangString noRoot ${LANG_SerbianLatin} "Ne možete da instalirate OpenBazaar u direktorijum koji zahteva administartorsku dozvolu"
LangString noRoot ${LANG_SimpChinese} "你不能把OpenBazaar安装到一个需要管理员权限的目录"
LangString noRoot ${LANG_Slovak} "Nemôžete inštalovať OpenBazaar do zložky, ktorá vyžaduje administrátorské povolenia"
LangString noRoot ${LANG_Slovenian} "Ne morete namestiti OpenBazaar v imeniku, ki zahteva skrbniška dovoljenja"
LangString noRoot ${LANG_Spanish} "OpenBazaar no puede ser instalado en un directorio que requiera permisos de administrador"
LangString noRoot ${LANG_SpanishInternational} "OpenBazaar no puede ser instalado en un directorio que requiera permisos de administrador"
LangString noRoot ${LANG_Swedish} "OpenBazaar kan inte installeras i en mapp som kräver administratörsbehörighet"
LangString noRoot ${LANG_Thai} "คุณไม่สามารถติดตั้ง OpenBazaar ในโฟลเดอร์ ที่ต้องใช้สิทธิ์ของ Administrator"
LangString noRoot ${LANG_TradChinese} "您不能於一個需要管理員權限才能存取的目錄安裝 OpenBazaar"
LangString noRoot ${LANG_Turkish} "OpenBazaar'ı yönetici izinleri gerektiren bir dizine kuramazsınız"
LangString noRoot ${LANG_Ukrainian} "Ви не можете встановити OpenBazaar в директорію для якої потрібні права адміністратора"
;LangString noRoot ${LANG_Vietnamese} "Bạn không thể cài đặt OpenBazaar trong một thư mục yêu cầu quyền quản trị admin"
LangString noRoot ${LANG_Welsh} "Ni gallwch gosod OpenBazaar mewn cyfarwyddiadur sydd angen caniatad gweinyddol"

LangString desktopShortcut ${LANG_ENGLISH} "Desktop Shortcut"
LangString desktopShortcut ${LANG_Afrikaans} "Snelkoppeling op die lessenaar (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Albanian} "Shkurtore desktop (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Arabic} "إختصار سطح المكتب"
LangString desktopShortcut ${LANG_Belarusian} "ярлык Працоўнага Стала (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Bosnian} "Prečac Radne Površine"
LangString desktopShortcut ${LANG_Bulgarian} "Икона на десктоп"
LangString desktopShortcut ${LANG_Catalan} "Drecera d'escriptori"
LangString desktopShortcut ${LANG_Croatian} "Prečac na radnoj površini (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Czech} "Odkaz na ploše"
LangString desktopShortcut ${LANG_Danish} "Genvej til skrivebord"
LangString desktopShortcut ${LANG_Dutch} "Bureaublad-snelkoppeling"
LangString desktopShortcut ${LANG_Esperanto} "Labortablo ŝparvojo (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Estonian} "Otsetee töölaual"
LangString desktopShortcut ${LANG_Farsi} "(Desktop Shortcut) میانبر دسک تاپ"
LangString desktopShortcut ${LANG_Finnish} "Työpöydän pikakuvake"
LangString desktopShortcut ${LANG_French} "Placer un raccourci sur le bureau"
LangString desktopShortcut ${LANG_Galician} "Atallo de escritorio"
LangString desktopShortcut ${LANG_German} "Desktopsymbol"
LangString desktopShortcut ${LANG_Greek} "Συντόμευση επιφάνειας εργασίας"
LangString desktopShortcut ${LANG_Hebrew} "קיצורי דרך על שולחן העבודה"
LangString desktopShortcut ${LANG_Hungarian} "Asztali ikon"
LangString desktopShortcut ${LANG_Icelandic} "Flýtileið (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Indonesian} "Desktop Shortcut"
LangString desktopShortcut ${LANG_Irish} "Aicearra deisce (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Italian} "Collegati sul desktop"
LangString desktopShortcut ${LANG_Japanese} "デスクトップショートカット"
LangString desktopShortcut ${LANG_Korean} "바탕화면 바로가기"
LangString desktopShortcut ${LANG_Latvian} "Desktop īsceļu (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Lithuanian} "Darbalaukio nuoroda"
LangString desktopShortcut ${LANG_Macedonian} "Десктоп кратенка (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Malay} "Pintasan Desktop"
LangString desktopShortcut ${LANG_Mongolian} "Ширээний товчлохын (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Norwegian} "Skrivebordssnarvei"
LangString desktopShortcut ${LANG_NorwegianNynorsk} "Skrivebordssnarvei"
LangString desktopShortcut ${LANG_Polish} "Ikona na pulpicie"
LangString desktopShortcut ${LANG_Portuguese} "Atalho do Ambiente de Trabalho"
LangString desktopShortcut ${LANG_PortugueseBR} "Atalho da Área de Trabalho"
LangString desktopShortcut ${LANG_Romanian} "Scurtătură desktop"
LangString desktopShortcut ${LANG_Russian} "Ярлык на рабочем столе"
LangString desktopShortcut ${LANG_Serbian} "Пречица на радној површини"
LangString desktopShortcut ${LANG_SerbianLatin} "Desktop Shortcut"
LangString desktopShortcut ${LANG_SimpChinese} "桌面快捷方式"
LangString desktopShortcut ${LANG_Slovak} "Odkaz na pracovnej ploche"
LangString desktopShortcut ${LANG_Slovenian} "Bližnjica na namizju"
LangString desktopShortcut ${LANG_Spanish} "Acceso directo en el Escritorio"
LangString desktopShortcut ${LANG_SpanishInternational} "Acceso directo en el Escritorio"
LangString desktopShortcut ${LANG_Swedish} "Genväg på skrivbordet"
LangString desktopShortcut ${LANG_Thai} "ไอคอนตรงพื้นโต๊ะ"
LangString desktopShortcut ${LANG_TradChinese} "桌面捷徑"
LangString desktopShortcut ${LANG_Turkish} "Masaüstü Kısayolu"
LangString desktopShortcut ${LANG_Ukrainian} "Ярлик на робочому столі"
;LangString desktopShortcut ${LANG_Vietnamese} "Lối tắt trên màn (Desktop Shortcut)"
LangString desktopShortcut ${LANG_Welsh} "Llwybr Byr ar y Bwrdd Gwaith"

; ------------------- ;
;    Install code     ;
; ------------------- ;
Function .onInit ; check for previous version
    Exec "taskkill /F /IM OpenBazaar.exe /T"
    ReadRegStr $0 HKCU "${UNINSTALL_KEY}" "InstallString"
    StrCmp $0 "" done
    StrCpy $INSTDIR $0
done:
FunctionEnd

Section ; App Files
    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    SetOutPath "$INSTDIR"
    File /r "../OpenBazaar-Client"
    File /r "../OpenBazaar-Server"
    File /r "OpenBazaar.ps1"
    File /r "icon.ico"
    File /r "systray.ico"
    File /r "install.ps1"
    File /r "systray.py"
    ;File /r "observice.py"

SectionEnd

Section ; pyNaCl Install

    DetailPrint "Configuring OpenBazaar (This can take a while)..."
    nsExec::ExecToStack `Powershell.exe -ExecutionPolicy ByPass -File $INSTDIR\install.ps1 $INSTDIR`
    Pop $0 # return value/error/timeout
	Pop $1 # printed text, up to ${NSIS_MAX_STRLEN}
SectionEnd

Section ; Set up Windows Service
    ;FileOpen $9 "$INSTDIR\start_openbazaar.bat" w
    ;FileWrite $9 "$INSTDIR\Python27\python.exe $INSTDIR\OpenBazaar-Server\openbazaard.py start"
    ;FileClose $9
    ;File /r "start_openbazaar.bat"

    ;SimpleSC::InstallService "OpenBazaar4" "OpenBazaar Server Daemon4" "16" "2" "$INSTDIR\start_openbazaar.bat" "" "" ""
    ;Pop $0 ; returns an errorcode (<>0) otherwise success (0)
    ;    IntCmp $0 0 Done +1 +1
    ;    Push $0
    ;    SimpleSC::GetErrorMessage
    ;    Pop $0
    ;    MessageBox MB_OK|MB_ICONSTOP "Stopping fails - Reason: $0"
    ;  Done:

    ;'nsExec::ExecToStack `$INSTDIR\Python27\python.exe $INSTDIR\observice.py install`
    ;Pop $0
    ;MessageBox MB_OK|MB_ICONSTOP "Result: $0"

SectionEnd

; ------------------- ;
;     Uninstaller     ;
; ------------------- ;
Section "uninstall"

    RMDir /r "$INSTDIR"
    RMDir /r "$SMPROGRAMS\${APP_NAME}"
    Delete "$DESKTOP\${APP_NAME}.lnk"

    ;MessageBox MB_YESNO|MB_ICONQUESTION "$(removeDataFolder)" IDNO NoUninstallData
    ;RMDir /r "$LOCALAPPDATA\${DATA_FOLDER}"
    ;NoUninstallData:
    ;DeleteRegKey HKCU "${UNINSTALL_KEY}"
    ;DeleteRegKey HKCU "Software\Chromium" ;workaround for NW leftovers
    ;DeleteRegKey HKCU "Software\Classes\Applications\${APP_LAUNCHER}" ;file association

SectionEnd

; ------------------ ;
;  Desktop Shortcut  ;
; ------------------ ;
Function finishpageaction
    CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "Powershell.exe" "-ExecutionPolicy ByPass -File OpenBazaar.ps1" "$INSTDIR\systray.ico" "" "" "" "${APP_NAME} ${PT_VERSION}"
FunctionEnd