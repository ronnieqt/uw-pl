
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

; ========== (1) ==========

(define (sequence low high stride)  ; stride>0
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))

; ========== (2) ==========

(define (string-append-map xs suffix)
  (map (lambda (x) (string-append x suffix)) xs))

; ========== (3) ==========

(define (list-nth-mod xs n)
  (cond [(< n 0)    (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (let ([i (remainder n (length xs))])
              (car (list-tail xs i)))]))

; ========== (4) ==========

(define (stream-for-n-steps s n)  ; n>=0
  (if (= n 0)
      null
      (let ([pr (s)])
        (cons (car pr) (stream-for-n-steps (cdr pr) (- n 1))))))

; ========== (5) ==========

(define (stream-maker x0 fn-next)
  (define (f x) (cons x (lambda () (f (fn-next x)))))
  (lambda () (f x0)))

(define funny-number-stream
  (stream-maker 1 (lambda (x) (let ([abs-x-next (+ (abs x) 1)])
                                (if (= 0 (remainder abs-x-next 5))
                                    (- abs-x-next)
                                    abs-x-next)))))

; ========== (6) ==========

(define dan-then-dog
  (stream-maker "dan.jpg" (lambda (x) (if (string=? x "dan.jpg") "dog.jpg" "dan.jpg"))))

; ========== (7) ==========

(define (stream-add-zero s)
  (let ([pr (s)])
    (lambda () (cons (cons 0 (car pr)) (stream-add-zero (cdr pr))))))

; ========== (8) ==========

(define (cycle-lists xs ys)  ; xs and ys are not empty
  (define (cycle-lists-aux n)
    (cons (cons (list-nth-mod xs n) (list-nth-mod ys n))
          (lambda () (cycle-lists-aux (+ n 1)))))
  (lambda () (cycle-lists-aux 0)))

; ========== (9) ==========

(define (vector-assoc v vec)
  (define (vector-assoc-aux i)
    (if (>= i (vector-length vec))
        #f
        (let ([x (vector-ref vec i)])
          (if (and (pair? x) (equal? v (car x)))
              x
              (vector-assoc-aux (+ i 1))))))
  (vector-assoc-aux 0))

; ========== (10) ==========

(define (cached-assoc xs n)  ; n>0
  (define memo (make-vector n #f))
  (define i-next 0)
  (define (f v)
    (let ([ans (vector-assoc v memo)])
      (if ans
          (cdr ans)
          (let ([new-ans (assoc v xs)])
            (begin (vector-set! memo i-next new-ans)
                   (set! i-next (remainder (+ i-next 1) n))
                   new-ans)))))
  f)

; ========== (11) ==========

(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (let ([ub e1])
       (letrec ([loop (lambda () (if (>= e2 ub)
                                     #t
                                     (loop)))])
         (loop)))]))
