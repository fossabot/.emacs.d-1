;;; helpers.el --- small helper functions -*- lexical-binding: t -*-

;;; Commentary:
;; 

;;;; Modalka

(defmacro modalka-reserve (transforms &rest keys)
  (declare (indent 1))
  `(modalka-multiplex
       (lambda () (interactive))
       ,transforms
     ,@keys))

(defmacro modalka-multiplex (command transforms &rest keys)
  (declare (indent 2))
  `(dolist (key ',keys)
     (dolist (transform ',transforms)
       (define-key modalka-mode-map
         (kbd (funcall transform key)) ,command))))

(defmacro modalka-keys (&rest keys)
  `(dolist (pair ',keys)
     (pcase pair
       (`(,key . ,(and command (pred symbolp)))
        (define-key modalka-mode-map (kbd key) command))
       (`(,key . ,(and command (pred listp)))
        (define-key modalka-mode-map (kbd key) `(lambda (&optional arg) (interactive "p") ,@command)))
       (otherwise (error "Invalid entry: %S" pair)))))

(defun modalka-deactivate ()
  (interactive)
  (modalka-mode -1))

;;;; Multiple-cursors

(defun mc/mark-down-or-more (arg)
  (interactive "p")
  (if (region-active-p)
      (dotimes (_ arg) (mc/mark-next-like-this 1))
    (mc/mark-next-lines arg)))

;;;; Editing commands

(defun kill-region-or-line (arg)
  (interactive "p")
  (if (region-active-p)
      (call-interactively 'kill-region)
    (kill-whole-line arg)))

(defun copy-region-or-line (arg)
  (interactive "p")
  (if (region-active-p)
      (call-interactively 'copy-region-as-kill)
    (let ((begin (point-at-bol)))
      (save-excursion
        (forward-line arg)
        (copy-region-as-kill begin (point-at-bol))))))

(defun goto-or-quit (arg)
  (interactive "P")
  (if (and (not (bound-and-true-p multiple-cursors-mode))
           (numberp arg))
      (if (> arg 0)
          (goto-line arg)
        (goto-line (+ arg (line-number-at-pos (point-max)))))
    (fi-universal-quit)))

(defun switch-mark-command ()
  (interactive)
  (if (region-active-p)
      (if (null rectangle-mark-mode)
          (rectangle-mark-mode)
        (deactivate-mark))
    (set-mark-command nil)))

;;;; Window management commands

(defun delete-window-or-frame ()
  (interactive)
  (unless (ignore-errors (delete-window) t)
    (unless (ignore-errors (delete-frame) t)
      (save-buffers-kill-emacs))))

(defun delete-window-or-buffer ()
  (interactive)
  (if (= (count-windows) 1)
      (kill-buffer)
    (delete-window)))

(defun delete-window-and-buffer ()
  (interactive)
  (if (= (count-windows) 1)
      (kill-buffer)
    (let ((b (current-buffer)))
      (delete-window)
      (kill-buffer b))))

(defun split-window-left (&optional size)
  (interactive)
  (split-window-right size)
  (other-window 1))

(defun split-window-above (&optional size)
  (interactive)
  (split-window-below size)
  (other-window 1))

;;;; Org-mode

(defun org-clip ()
  (interactive)
  (if (region-active-p)
      (let ((old (region-beginning)))
        (setf (point) old)
        (insert "[[")
        (insert (org-cliplink-clipboard-content))
        (insert "][")
        (setf (point) (region-end))
        (insert "]]")
        (setf (point) old))
    (org-cliplink)))

(defun org-clean-description (str)
  (car (split-string str " [-–|]" t)))

;;;; Lispy

(defun conditionally-enable-lispy ()
  (when (eq this-command 'eval-expression)
    (lispy-mode 1)))

;;;; Ivy

(defun ivy-insert-selection ()
  (interactive)
  (ivy-exit-with-action
   (lambda (it)
     (interactive)
     (insert it)
     (signal 'quit nil))))

(defun counsel-lookup-symbol ()
  "Lookup the current symbol in the help docs."
  (interactive)
  (ivy-exit-with-action
   (lambda (x)
     (if (featurep 'helpful)
         (helpful-symbol (intern x))
       (describe-symbol (intern x))
       (signal 'quit nil)))))

;;; helpers.el ends here
