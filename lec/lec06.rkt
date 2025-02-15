#lang racket
; ============================================================
; datatype programming in Racket without structs

; helper functions (ctors) that make lists where the first element is a symbol
(define (Const i) (list 'Const  i))  ; 'Const is symbol
(define (Negate e) (list 'Negate e))
(define (Add e1 e2) (list 'Add e1 e2))
(define (Multiply e1 e2) (list 'Multiply e1 e2))

; helper functions that test what "kind of exp" (test-variant - to mimic ML's pattern-matching)
(define (Const? x) (eq? (car x) 'Const))
(define (Negate? x) (eq? (car x) 'Negate))
(define (Add? x) (eq? (car x) 'Add))
(define (Multiply? x) (eq? (car x) 'Multiply))

; helper functions (getters) that get the pieces for "one kind of exp"
(define (Const-int e) (car (cdr e)))  ; second element of the list e
(define (Negate-e e) (car (cdr e)))
(define (Add-e1 e) (car (cdr e)))
(define (Add-e2 e) (car (cdr (cdr e))))
(define (Multiply-e1 e) (car (cdr e)))
(define (Multiply-e2 e) (car (cdr (cdr e))))

(define (evalExp e)
  (cond [(Const? e) e]
        [(Negate? e) (Const (- (Const-int (evalExp (Negate-e e)))))]
        [(Add? e) (let ([v1 (Const-int (evalExp (Add-e1 e)))]
                        [v2 (Const-int (evalExp (Add-e2 e)))])
                    (Const (+ v1 v2)))]
        [(Multiply? e) (let ([v1 (Const-int (evalExp (Multiply-e1 e)))]
                             [v2 (Const-int (evalExp (Multiply-e2 e)))])
                         (Const (* v1 v2)))]
        [#t (error "evalExp expected an expression")]))

(println (evalExp (Multiply (Add (Const 3) (Negate (Const 1))) (Const 10))))

; ============================================================
; datatype programming in Racket with structs

; (struct <struct-name> (<field-1 field-2 field-3) #:transparent)
; the corresponding ctor, tester, and getter are defined automatically

; struct is similar to ML's constructor
; struct creates a new kind of data
(struct const (int) #:transparent)
(struct negate (e) #:transparent)
(struct add (e1 e2) #:transparent)
(struct multiply (e1 e2) #:transparent)

(define (eval-exp e)
  (cond [(const? e) e]
        [(negate? e) (const (- (const-int (eval-exp (negate-e e)))))]
        [(add? e) (let ([v1 (const-int (eval-exp (add-e1 e)))]
                        [v2 (const-int (eval-exp (add-e2 e)))])
                    (const (+ v1 v2)))]
        [(multiply? e) (let ([v1 (const-int (eval-exp (multiply-e1 e)))]
                             [v2 (const-int (eval-exp (multiply-e2 e)))])
                         (const (* v1 v2)))]
        [#t (error "eval-exp expected an expression")]))

(println (eval-exp (multiply (add (const 3) (negate (const 1))) (const 10))))

; ============================================================
