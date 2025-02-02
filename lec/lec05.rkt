; always make this the first (non-comment, non-blank) line of your file
#lang racket

; not needed here, but a workaround so we could write tests in a second file
(provide (all-defined-out))

; basic definitions
(define x 3)        ; val x = 3
(define y (+ x 2))  ; + is a function

; ========== function definitions ==========

; function calls: (e0 e1 ... en)
; call a function f with zero argument: (f)

(define cube1
  (lambda (x)       ; lambda (x) is an anonymous function; like fn (x) in ML
    (* x (* x x))))

(define cube2
  (lambda (x)
    (* x x x)))

(define (cube3 x)    ; a syntactic sugar for the above (cube2) def
  (* x x x))

(define (pow1 x y)
  (if (= y 0)
      1
      (* x (pow1 x (- y 1)))))

(define pow2  ; currying
  (lambda (x)
    (lambda (y)
      (pow1 x y))))

(define three-to-the (pow2 3))
(define sixteen ((pow2 4) 2))

; ========== lists ==========

; '(4 5 6) = (cons 4 (cons 5 (cons 6 null))) = (list 4 5 6)

(define (sum xs)
  (if (null? xs)
      0
      (+ (car xs) (sum (cdr xs)))))  ; car: hd, cdr: tl

(define res (sum (list 3 4 5)))

(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))

(define (my-map f xs)
  (if (null? xs)
      null
      (cons (f (car xs)) (my-map f (cdr xs)))))

(define (my-sum-deep xs)
  (cond [(null? xs) 0]  ; use cond for nested if-else
        [(number? (car xs)) (+ (car xs) (my-sum-deep (cdr xs)))]
        [#t (+ (my-sum-deep (car xs)) (my-sum-deep (cdr xs)))]))

(set! res (my-sum-deep (list 1 2 (list 3 4) 5 (list (list 6)))))  ; assignment statement

(define pr  (cons 1 (cons 2 3)))              ; a pair (cons builds a pair)
(define lst (cons 1 (cons 2 (cons 3 null))))  ; a list (the last element must be null)

; ========== local bindings ==========

; (let ([x1 e1] [x2 e2] ... [xn en]) body)

(define (max-of-list xs)
  (cond [(null? xs) (error "given an empty list")]
        [(null? (cdr xs)) (car xs)]
        [#t (let ([tl_ans (max-of-list (cdr xs))])
              (if (> tl_ans (car xs)) tl_ans (car xs)))]))

(set! res (max-of-list (list 1 5 2)))

; ========== delay evaluation ==========

(define (my-if e1 e2 e3)
  ; e2 and e3 are zero-arg functions used to delay evaluation
  ; NOTE: expressions in a function body won't be evaluated until the function is called
  (if e1 (e2) (e3)))

(define (fact n)
  (my-if (= n 0)
         (lambda () 1)  ; this zero-arg function is called a thunk
         (lambda () (* n (fact (- n 1))))))

; ========== lazy evaluation ==========

; assuming some expensive computation has no side effects, ideally we would
; - not compute it until needed
; - remember the answer so future uses complete immediately

(define (my-delay th)  ; th: thunk
  (mcons #f th))       ; returns a promise

(define (my-force p)   ; p: promise
  (if (mcar p)  ; (#1 p)
      (mcdr p)  ; (#2 p)
      (begin (set-mcar! p #t)  ; (begin e1 e2 ... en): evaluate exprs in sequence
             (set-mcdr! p ((mcdr p)))
             (mcdr p))))

; this is a silly addition function that purposely runs slows for demonstration purposes
(define (slow-add x y)
  (letrec ([slow-id (lambda (y z) (if (= 0 z) y (slow-id y (- z 1))))])
    (+ (slow-id x 50000000) y)))

(define (my-mult x y-p)
  (cond [(= x 0) 0]
        [(= x 1) (my-force y-p)]
        [#t (+ (my-force y-p) (my-mult (- x 1) y-p))]))

; th -> my-delay -> p -> f -> result
; (slow-add 3 4) is only evaluated when the first time we call my-force on the promise (p)
(my-mult 10 (my-delay (lambda () (slow-add 3 4))))

(define-syntax macro-delay
  (syntax-rules ()
    [(macro-delay e)
     (mcons #f (lambda () e))]))

(my-mult 10 (macro-delay (slow-add 3 4)))

; ========== Streams ==========

; stream: a thunk that when called returns a pair '(current-element . next-stream-thunk)

; 1 1 1 1 1 1 ...
(define ones (lambda () (cons 1 ones)))

; 1 2 3 4 5 ...
(define nats-v1
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

; 2 4 8 16 ...
(define power-of-two-v1
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))

; abstraction
(define (stream-maker x0 fn-next)
  (define (f x) (cons x (lambda () (f (fn-next x)))))
  (lambda () (f x0)))

; (define (stream-maker-letrec x0 fn-next)
;   (letrec ([f (lambda (x) (cons x (lambda () (f (fn-next x)))))])
;     (lambda () (f x0))))

(define nats-v2 (stream-maker 1 (lambda (x) (+ x 1))))
(define power-of-two-v2 (stream-maker 2 (lambda (x) (* x 2))))

; ========== Memoization ==========

(define fibo
  (letrec ([memo null]  ; memo: list of pairs (arg . result)
           [f (lambda (x)
                (let ([ans (assoc x memo)])  ; check if x is in memo (comparing x with arg)
                  (if ans
                      (cdr ans)
                      (let ([new-ans (if (or (= x 1) (= x 2))
                                         1
                                         (+ (f (- x 1)) (f (- x 2))))])
                        (begin (set! memo (cons (cons x new-ans) memo)) new-ans)))))])
    f))

(fibo 30)

; ========== Macros ==========

; Macros: allow programmers to add more syntactic sugar to the language

(define-syntax macro-if
  (syntax-rules (then else)
    [(macro-if e1 then e2 else e3)  ; <- whenever you see sth like this
     (if e1 e2 e3)]))               ; <- replace it with this

(macro-if #f then 1 else 0)

(define-syntax comment-out
  (syntax-rules ()
    [(comment-out e1 e2) e2]))

(comment-out (car null) (+ 3 4))

(define-syntax macro-for
  (syntax-rules (to do)
    [(for lo to hi do body)
     (let ([l lo] [h hi])  ; lo is evaluated before hi; lo and hi will only be evaluated once
       (letrec ([loop (lambda (it) (if (> it h)
                                       #t
                                       (begin body (loop (+ it 1)))))])
         (loop l)))]))

(macro-for ((lambda (x) (begin (print "A") x)) 7)
           to ((lambda (x) (begin (print "B") x)) 11)
           do ((lambda (x) (begin (print "C") x)) 9))

(define-syntax let2
  (syntax-rules ()
    [(let2 () body) body]
    [(let2 (var val) body) (let ([var val]) body)]
    [(let2 (var1 val1 var2 val2) body) (let ([var1 val1]) (let ([var2 val2]) body))]))

(define-syntax macro-let*
  (syntax-rules ()
    [(macro-let* () body) body]
    [(macro-let* ([var0 val0] [var-rest val-rest] ...) body)
     (let ([var0 val0]) (macro-let* ([var-rest val-rest] ...) body))]))  ; recursive macro
