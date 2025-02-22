#lang racket
;; Programming Languages Homework 5 Simple Test
;; Save this file to the same directory as your homework file
;; These are basic tests. Passing these tests does not guarantee that your code will pass the actual homework grader

;; Be sure to put your homework file in the same folder as this test file.
;; Uncomment the line below and, if necessary, change the filename
(require "hw5.rkt")

(require rackunit)

(define tests
  (test-suite
   "Sample tests for Assignment 5"

   ;; check racketlist to mupllist with normal list
   (check-equal? (racketlist->mupllist (list (int 3) (int 4)))
                 (apair (int 3) (apair (int 4) (aunit))) "racketlist->mupllist test 1")
   (check-equal? (racketlist->mupllist (list 1))
                 (apair 1 (aunit)) "racketlist->mupllist test 2")
   (check-equal? (racketlist->mupllist null)
                 (aunit) "racketlist->mupllist test 3")

   ;; check mupllist to racketlist with normal list
   (check-equal? (mupllist->racketlist (apair (int 3) (apair (int 4) (aunit))))
                 (list (int 3) (int 4)) "mupllist->racketlist test 1")
   (check-equal? (mupllist->racketlist (apair (int 3) (aunit)))
                 (list (int 3)) "mupllist->racketlist test 2")
   (check-equal? (mupllist->racketlist (aunit))
                 null "mupllist->racketlist test 3")

   ;; tests values: int, closure, aunit, apair
   (check-equal? (eval-exp (int 17)) (int 17) "int test")
   (check-equal? (eval-exp (closure '() (fun #f "x" (add (var "x") (int 7)))))
                 (closure '() (fun #f "x" (add (var "x") (int 7)))) "closure test")
   (check-equal? (eval-exp (aunit)) (aunit) "aunit test")
   (check-equal? (eval-exp (apair (add (int 1) (int 2)) (int 4))) (apair (int 3) (int 4)) "apair test")

   ;; tests if ifgreater returns (int 2)
   (check-equal? (eval-exp (ifgreater (int 3) (int 4) (int 3) (int 2))) (int 2) "ifgreater test 1")
   (check-equal? (eval-exp (ifgreater (int 4) (int 3) (int 3) (int 2))) (int 3) "ifgreater test 2")

   ;; tests fun
   (check-equal? (eval-under-env (fun "my-fn" "x" (add (var "x") (int 7))) (list (cons "x" 1)))
                 (closure (list (cons "x" 1)) (fun "my-fn" "x" (add (var "x") (int 7)))) "fun test")

   ;; mlet test
   (check-equal? (eval-exp (mlet "x" (int  1) (add (int 5) (var "x")))) (int 6) "mlet test 1")
   (check-equal? (eval-exp (mlet "x" (int -1) (add (int 5) (var "x")))) (int 4) "mlet test 2")

   ;; call test
   (check-equal? (eval-exp (call (closure '() (fun #f "x" (add (var "x") (int 7)))) (int 1))) (int 8) "call test 1")
   (check-equal? (eval-exp (call (closure (list (cons "y" (int 10))) (fun #f "x" (add (var "x") (var "y")))) (int 1))) (int 11) "call test 2")
   (check-equal? (eval-exp (call (closure (list (cons "y" (int 10))) (fun #f "x" (add (var "x") (int 1)))) (int 2))) (int 3) "call test 3")
   (check-equal? (eval-exp (call (closure (list (cons "x" (int 10))) (fun #f "x" (add (var "x") (int 1)))) (int 2))) (int 3) "call test 4")
   (check-equal? (eval-exp (call (eval-under-env (fun "myfn" "x" (mlet "z" (add (var "x") (int -1))
                                                                       (ifgreater (var "x") (int 0)
                                                                                  (add (var "y") (call (var "myfn") (var "z")))
                                                                                  (int 10))))
                                                 (list (cons "y" (int 5))))
                                 (int 3))) (int 25) "call test 5")
   (check-equal? (eval-exp (call (eval-under-env (fun "myfn" "x" (mlet "z" (add (fst (var "x")) (int -1))
                                                                       (ifgreater (var "z") (int -1)
                                                                                  (call (var "myfn") (apair (var "z") (add (var "y") (snd (var "x")))))
                                                                                  (add (int 10) (snd (var "x"))))))
                                                 (list (cons "y" (int 5))))
                                 (apair (int 3) (int 0)))) (int 25) "call test 6")

   ;;fst test
   (check-equal? (eval-exp (fst (apair (int 1) (int 2)))) (int 1) "fst test")

   ;;snd test
   (check-equal? (eval-exp (snd (apair (int 1) (int 2)))) (int 2) "snd test")

   ;; isaunit test
   (check-equal? (eval-exp (isaunit (closure '() (fun #f "x" (aunit))))) (int 0) "isaunit test 1")
   (check-equal? (eval-exp (isaunit (call (closure '() (fun #f "x" (aunit))) (aunit)))) (int 1) "isaunit test 2")

   ;; ifaunit test
   (check-equal? (eval-exp (ifaunit (int 1) (int 2) (int 3))) (int 3) "ifaunit test 1")
   (check-equal? (eval-exp (ifaunit (aunit) (int 2) (int 3))) (int 2) "ifaunit test 2")

   ;; mlet* test
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10))) (var "x"))) (int 10) "mlet* test 1")
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 1)) (cons "y" (int 2))) (add (var "x") (var "y"))))
                 (int 3) "mlet* test 2")
   (check-equal? (eval-exp (mlet* (list (cons "f1" (fun #f "x" (add (var "x") (int 1))))
                                        (cons "f2" (fun #f "y" (add (var "y") (int 2)))))
                                  (add (call (var "f1") (int 10))
                                       (call (var "f2") (int 20)))))
                 (int 33) "mlet test 3")

   ;; ifeq test
   (check-equal? (eval-exp (ifeq (int 1) (int 2) (int 3) (int 4))) (int 4) "ifeq test 1")
   (check-equal? (eval-exp (ifeq (int 1) (int 1) (int 3) (int 4))) (int 3) "ifeq test 2")

   ;; mupl-map test
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 7)))) (apair (int 1) (aunit))))
                 (apair (int 8) (aunit)) "mupl-map test 1")
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 6))))
                                 (racketlist->mupllist (list (int 1) (int 2) (int 3)))))
                 (racketlist->mupllist (list (int 7) (int 8) (int 9))) "mupl-map test 2")

   ;; problems 1, 2, and 4 combined test
   (check-equal? (mupllist->racketlist
                  (eval-exp (call (call mupl-mapAddN (int 7))
                                  (racketlist->mupllist
                                   (list (int 3) (int 4) (int 9)))))) (list (int 10) (int 11) (int 16)) "combined test")

   ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)
