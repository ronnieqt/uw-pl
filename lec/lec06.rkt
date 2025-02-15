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
(struct const (int) #:transparent)               ; value
(struct bool (b) #:transparent)                  ; value
(struct negate (e) #:transparent)                ; expression
(struct add (e1 e2) #:transparent)               ; expression
(struct multiply (e1 e2) #:transparent)          ; expression
(struct eq-num (e1 e2) #:transparent)            ; expression
(struct if-then-else (e1 e2 e3) #:transparent)   ; expression

; interpreter should always a value - a kind of expression that evaluates to itself
(define (eval-exp e)
  (cond [(const? e) e]
        [(bool? e) e]
        [(negate? e)
         (let ([v (eval-exp (negate-e e))])
           ; NOTE: when you get a value as a recursive result back from your interpreter,
           ;       you need to check what kind of value you got
           (if (const? v)  ; .
               (const (- (const-int (eval-exp (negate-e e)))))
               (error "negate applied to non-number")))]
        [(add? e)
         (let ([v1 (eval-exp (add-e1 e))]
               [v2 (eval-exp (add-e2 e))])
           (if (and (const? v1) (const? v2))
               (const (+ (const-int v1) (const-int v2)))
               (error "add applied to non-number")))]
        [(multiply? e)
         (let ([v1 (eval-exp (multiply-e1 e))]
               [v2 (eval-exp (multiply-e2 e))])
           (if (and (const? v1) (const? v2))
               (const (* (const-int v1) (const-int v2)))
               ((error "multiply applied to non-number"))))]
        [(eq-num? e)
         (let ([v1 (eval-exp (eq-num-e1 e))]
               [v2 (eval-exp (eq-num-e2 e))])
           (if (and (const? v1) (const? v2))
               (bool (= (const-int v1) (const-int v2)))
               (error "eq-num applied to non-number")))]
        [(if-then-else? e)
         (let ([v-test (eval-exp (if-then-else-e1 e))])
           (if (bool? v-test)
               (if (bool-b v-test)
                   (eval-exp (if-then-else-e2 e))
                   (eval-exp (if-then-else-e3 e)))
               (error "if-then-else applied to non-boolean")))]
        [#t (error "eval-exp expected an expression")]))

; macros - racket functions act like macros for our new language
; a macro produces an expression in the language being implemented
(define (and-also e1 e2)
  (if-then-else e1 e2 (bool #f)))

(define (double e)
  (multiply e (const 2)))

(define (list-product es)
  (if (null? es)
      (const 1)
      (multiply (car es) (list-product (cdr es)))))

(println (eval-exp (multiply (add (const 3) (negate (const 1))) (const 10))))

(define test1 (multiply (negate (add (const 2)
                                     (const 2)))
                        (const 7)))

(define test2 (multiply (negate (add (const 2)
                                     (const 2)))
                        (if-then-else (bool #f)
                                      (const 7)
                                      (bool #t))))

; test3 is a big piece of syntax
; the point is to produce syntax that represents the expanded expression
; so that we can then evaluate it and get our results
(define test3 (and-also (eq-num (double (const 4))
                                (list-product (list (const 2) (const 2) (const 1) (const 2))))
                        (bool #t)))

(println (eval-exp test3))

; ============================================================
