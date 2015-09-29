import win32serviceutil
import subprocess


SERVICE_NAME = "OpenBazaarService"
SERVICE_DISPLAY_NAME = "OpenBazaar Server Service"
SERVICE_DESCRIPTION = """This service controls the openbazaard service."""


class OpenBazaarService(win32serviceutil.ServiceFramework):
    """OpenBazaar Server Service."""

    _svc_name_ = SERVICE_NAME
    _svc_display_name_ = SERVICE_DISPLAY_NAME
    _svc_deps_ = None
    _svc_description_ = SERVICE_DESCRIPTION

    def SvcDoRun(self):
        # Fire off openbazaard
        subprocess.Popen(["python", "../OpenBazaar-Server/openbazaard.py", "start"])

    def SvcStop(self):
        # Stop openbazaard
        subprocess.Popen(["python", "../OpenBazaar-Server/openbazaard.py", "stop"])


if __name__ == '__main__':
    win32serviceutil.HandleCommandLine(OpenBazaarService)
