;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var       (string)          #:transparent)  ;; a variable, e.g., (var "foo")
(struct int       (num)             #:transparent)  ;; a constant number, e.g., (int 17)
(struct add       (e1 e2)           #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)     #:transparent)  ;; if e1 > e2 then e3 else e4
(struct fun       (name param body) #:transparent)  ;; a recursive(?) 1-argument function
(struct call      (funexp argexp)   #:transparent)  ;; function call
(struct mlet      (var e body)      #:transparent)  ;; a local binding (let var = e in body)
(struct apair     (e1 e2)           #:transparent)  ;; make a new pair
(struct fst       (e)               #:transparent)  ;; get first part of a pair
(struct snd       (e)               #:transparent)  ;; get second part of a pair
(struct aunit     ()                #:transparent)  ;; unit value -- good for ending a list
(struct isaunit   (e)               #:transparent)  ;; evaluate to 1 if e is unit else 0
;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure   (env fun)         #:transparent)

;; MUPL value: int, closure, aunit, a pair of values, or a list

;; (fun <name> <param> <body>) <=> def <name>(<param>): <body>

;; Problem 1

(define (racketlist->mupllist xs)
  (if (null? xs)
      (aunit)
      (apair (car xs) (racketlist->mupllist (cdr xs)))))

(define (mupllist->racketlist xs)
  (if (aunit? xs)
      null
      (cons (apair-e1 xs) (mupllist->racketlist (apair-e2 xs)))))

;; Problem 2

;; lookup a variable in an environment (env: a Racket list of Racket pairs)
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  ;; e   : a MUPL expression
  ;; env : a list of (key str, MUPL value) pair
  (cond ;; --- values ---
        [(int?     e) e]
        [(aunit?   e) e]
        [(closure? e) e]
        ;; --- expressions ---
        [(var? e)
         (envlookup env (var-string e))]
        [(add? e)
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1) (int? v2))
               (int (+ (int-num v1) (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1) (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error "MUPL ifgreater conditions are not numbers")))]
        [(fun? e)
         (closure env e)]
        [(call? e)
         (let ([e1 (eval-under-env (call-funexp e) env)])
           (if (closure? e1)
               (let* ([func      (closure-fun e1)]
                      [env-clo   (closure-env e1)]
                      [pr-fn2clo (cons (fun-name  func) e1)]
                      [pr-pn2val (cons (fun-param func) (eval-under-env (call-argexp e) env))]
                      [env-ext   (if (car  pr-fn2clo)
                                     (cons pr-fn2clo (cons pr-pn2val env-clo))
                                     (cons pr-pn2val env-clo))])
                  (eval-under-env (fun-body func) env-ext))
               (error "MUPL call applied to non-closure")))]
        [(mlet? e)
         (let* ([v (eval-under-env (mlet-e e) env)]
                [env-ext (cons (cons (mlet-var e) v) env)])
           (eval-under-env (mlet-body e) env-ext))]
        [(apair? e)
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]
        [(fst? e)
         (let ([v (eval-under-env (fst-e e) env)])
           (if (apair? v)
               (apair-e1 v)
               (error "MUPL fst applied to non-apair")))]
        [(snd? e)
         (let ([v (eval-under-env (snd-e e) env)])
           (if (apair? v)
               (apair-e2 v)
               (error "MUPL snd applied to non-apair")))]
        [(isaunit? e)
         (let ([v (eval-under-env (isaunit-e e) env)])
           (if (aunit? v) (int 1) (int 0)))]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))

;; Problem 3

(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2
      (mlet (caar lstlst) (cdar lstlst) (mlet* (cdr lstlst) e2))))

(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2))
         (ifgreater (var "_x") (var "_y") e4
                    (ifgreater (var "_y") (var "_x") e4 e3))))

;; Problem 4

; NOTE: the following variable binding (in racket) represents a function in MUPL
; usage: (eval-exp (call <racket-var> <mupl-arg>))

(define mupl-map
  (fun #f "fn"
       (fun "_map_impl" "xs"
            (ifaunit (var "xs")
                     (aunit)
                     (apair (call (var "fn") (fst (var "xs")))
                            (call (var "_map_impl") (snd (var "xs"))))))))

(define mupl-mapAddN
  (mlet "map" mupl-map
        (fun #f "i"
             (call (var "map") (fun #f "x" (add (var "x") (var "i")))))))

;; Challenge Problem

(struct fun-challenge (name param body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
