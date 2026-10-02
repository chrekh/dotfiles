;;; ...  -*- lexical-binding: t -*-

(defvar html-timestamp-start "<!-- hhmts start --> ")
(defvar html-timestamp-end "<!-- hhmts end -->" )

(defun html-insert-timestamp ()
  "Insert a timestamp"
  (let ((time (current-time-string)))
    (insert "Last modified: "
            (substring time 0 20)
            (nth 1 (current-time-zone))
            " "
            (substring time -4)
            " ")))

(defun html-update-timestamp ()
  (save-excursion
    (goto-char (point-max))
    (if (not (search-backward html-timestamp-start nil t))
        (message "timestamp delimiter start was not found")
      (let ((ts-start (+ (point) (length html-timestamp-start)))
            (ts-end (if (search-forward html-timestamp-end nil t)
                        (- (point) (length html-timestamp-end))
                      nil)))
        (if (not ts-end)
            (message "timestamp delimiter end was not found.")
          (delete-region ts-start ts-end)
          (goto-char ts-start)
          (html-insert-timestamp)))))
  nil)

(add-hook 'html-mode-hook
          (lambda ()
            (add-hook 'local-write-file-hooks 'html-update-timestamp)))
