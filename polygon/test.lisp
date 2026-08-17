;;;; ============ 1. КОММЕНТАРИИ ============
;; однострочный комментарий (двойная точка с запятой)
;;; комментарий уровня секции (тройная)
#| блочный
   многострочный комментарий |#

;; ============ 2. ОПРЕДЕЛЕНИЕ ПАКЕТА ============
(defpackage :theme-test
  (:use :common-lisp)
  (:export :main :area :classify))

(in-package :theme-test)

;; ============ 3. ЛИТЕРАЛЫ ============
(defparameter *int-dec* 42)
(defparameter *int-neg* -17)
(defparameter *float-num* 3.14159)
(defparameter *ratio-num* 22/7)
(defparameter *hex-num* #xFF00FF)
(defparameter *oct-num* #o755)
(defparameter *bin-num* #b1010)
(defparameter *bool-true* t)
(defparameter *bool-false* nil)
(defparameter *char-val* #\A)
(defparameter *keyword-val* :some-keyword)

;; ============ 4. СТРОКИ ============
(defparameter *simple-string* "обычная строка")
(defparameter *escaped-string* "с \"кавычками\" и переводом \\n")

;; ============ 5. СПИСКИ И ДРУГИЕ СТРУКТУРЫ ============
(defparameter *simple-list* '(1 2 3 four "five"))
(defparameter *nested-list* '((1 2) (3 4) (5 6)))
(defparameter *cons-cell* (cons 1 2))
(defparameter *vector-val* #(1 2 3 4))
(defparameter *alist* '((name . "Алиса") (age . 25)))
(defparameter *plist* '(:name "Алиса" :age 25))

;; ============ 6. СТРУКТУРЫ И КЛАССЫ (CLOS) ============
(defstruct point
  (x 0.0 :type double-float)
  (y 0.0 :type double-float))

(defclass shape ()
  ((name :initarg :name :accessor shape-name)
   (color :initarg :color :initform "black" :accessor shape-color)))

(defclass circle (shape)
  ((radius :initarg :radius :accessor circle-radius)))

(defgeneric area (shape))

(defmethod area ((c circle))
  (* pi (circle-radius c) (circle-radius c)))

(defmethod area ((s shape))
  0.0)

;; ============ 7. ФУНКЦИИ ============
(defun square (x)
  "Docstring функции: возвращает квадрат числа."
  (* x x))

(defun add (a &optional (b 10) &rest more)
  (apply #'+ a b more))

(defun keyword-args (&key (name "default") (age 0))
  (list name age))

(defmacro my-when (condition &body body)
  `(if ,condition (progn ,@body) nil))

;; ============ 8. LAMBDA И ФУНКЦИИ ВЫСШЕГО ПОРЯДКА ============
(defparameter *doubler* (lambda (x) (* x 2)))
(defparameter *doubled-list* (mapcar (lambda (x) (* x 2)) '(1 2 3)))
(defparameter *filtered-list* (remove-if-not #'evenp '(1 2 3 4 5 6)))

;; ============ 9. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
(defun control-flow (value)
  (if (> value 10)
      (format t "большое~%")
      (format t "маленькое~%"))

  (when (> value 0)
    (format t "положительное~%"))

  (unless (< value 0)
    (format t "не отрицательное~%"))

  (cond
    ((> value 10) "большое")
    ((> value 0) "положительное")
    (t "другое"))

  (case value
    (0 "ноль")
    ((1 2 3) "малое")
    (otherwise "другое"))

  (dotimes (i 5)
    (format t "итерация ~a~%" i))

  (dolist (item '(1 2 3))
    (format t "элемент: ~a~%" item))

  (loop for i from 1 to 10
        when (evenp i)
        collect i))

;; ============ 10. LET И РЕКУРСИЯ ============
(defun calculate (x)
  (let* ((y (* x 2))
         (z (+ y 1)))
    (+ y z)))

(defun fibonacci (n)
  (if (<= n 1)
      n
      (+ (fibonacci (- n 1)) (fibonacci (- n 2)))))

;; ============ 11. ОБРАБОТКА ОШИБОК ============
(defun safe-divide (a b)
  (handler-case
      (/ a b)
    (division-by-zero (e)
      (format t "ошибка: деление на ноль~%")
      nil)
    (error (e)
      (format t "неизвестная ошибка: ~a~%" e)
      nil)))

;; ============ 12. MAIN ============
(defun main ()
  (let ((c (make-instance 'circle :name "круг" :radius 5.0)))
    (format t "Площадь: ~,2f~%" (area c))
    (control-flow 5)
    (format t "Фибоначчи(10): ~a~%" (fibonacci 10))
    (safe-divide 10 0)))

(main)
