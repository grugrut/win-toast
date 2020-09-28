;;; win-toast.el ---    -*- lexical-binding: t -*-
;; Author: grugrut <grugruglut+github@gmail.com>
;; URL: https://github.com/grugrut/win-toast
;; Version: 1.00

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(defvar win-toast--message-template "
$template = @\"
<toast>
    <visual>
        <binding template=\"ToastText02\">
            <text id=\"1\">__TITLE__</text>
            <text id=\"2\">__BODY__</text>
        </binding>
    </visual>
</toast>
\"@")

(defvar win-toast--notify-function "
$AppId = \"{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\\WindowsPowerShell\\v1.0\\powershell.exe\"
$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
$null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($template)

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($xml)
")

;;;###autoload
(defun win-toast (title body)
  "Notify with toast.  Message contain TITLE and BODY."
  (with-temp-buffer
    (insert (replace-regexp-in-string "__BODY__" body
                                      (replace-regexp-in-string "__TITLE__" title win-toast--message-template t) t))
    (insert win-toast--notify-function)
    (call-process-region (point-min) (point-max) "powershell.exe" nil "*result*" nil)))
(provide 'win-toast)

;;; win-toast.el ends here
