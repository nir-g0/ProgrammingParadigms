#lang racket

;; Exported methods and structs
(provide evaluate
         sp-val sp-binop sp-if sp-while
         sp-assign sp-var sp-seq)

;; Expressions in the language
(struct sp-val (val))
(struct sp-binop (op exp1 exp2))
(struct sp-if (c thn els))
(struct sp-while (c body))
(struct sp-assign (var exp))
(struct sp-var (varname))
(struct sp-seq (exp1 exp2))

;; An expression is represented by one of our structs above.
(define (expression? e)
  (match e
    [(struct sp-val (_)) #t]
    [(struct sp-binop (_ _ _)) #t]
    [(struct sp-if (_ _ _)) #t]
    [(struct sp-while (_ _)) #t]
    [(struct sp-assign (_ _)) #t]
    [(struct sp-var (_)) #t]
    [(struct sp-seq (_ _)) #t]
    [_ #f]))

;; An environment is a hash mapping variables to their values.
(define (environment? env)
  (hash/c string? value?))

;; A value will be either a Scheme boolean value or a Scheme number.
(define (value? v)
  (or (number? v)
      (boolean? v)))

(define (value-environment-pair? p)
  (and (value? (car p))
       (environment? (cdr p))))

;; Main evaluate method
(define/contract (evaluate prog env)
  (-> expression? environment? value-environment-pair?)
  (match prog
    [(struct sp-val (v))              (cons v env)] ;; We return a pair of the value and the environment.
    [(struct sp-binop (op exp1 exp2)) (eval-binop op exp1 exp2 env)]
    [(struct sp-if (c thn els))       (eval-if c thn els env)]
    [(struct sp-while (c body))       (eval-while c body env)]
    [(struct sp-assign (var exp))     (eval-assign var exp env)]
    [(struct sp-var (varname))        (cons (hash-ref env varname) env)]
    [(struct sp-seq (exp1 exp2))      (eval-seq exp1 exp2 env)]
    [_                                (error "Unrecognized expression")]))

;; Applies a binary argument to two arguments
(define (eval-binop op e1 e2 env)
  (let* ([r1 (evaluate e1 env)]        ;; Evaluate the lhs expression first
         [v1 (car r1)] [env1 (cdr r1)]
         [r2 (evaluate e2 env1)]       ;; Evaluate the rhs expression second
         [v2 (car r2)] [env2 (cdr r2)])
    (cons (apply op (list v1 v2))      ;; Apply the binary operator to its arguments
          env2)))

;; Evaluates a conditional expression
(define (eval-if c thn els env)
  (if (car (evaluate c env))
      [evaluate thn env]
      [evaluate els env]))

;; Evaluates a loop.
;; When the condition is false, return 0.
;; There is nothing special about zero -- we just need to return something.
(define (eval-while c body env)
  (if (car (evaluate c env))
        (eval-while c body [cdr (evaluate body env)])
      (evaluate (sp-val 0) env)))


;; Handles imperative updates.
(define (eval-assign var exp env)
  (let* ((val (evaluate exp env))   ; Evaluate the expression to get the value
         (new-env (hash-set env var [car val])))  ; Update the environment with the new value
  (evaluate exp new-env)))  ; Return the value and updated environment as a pair



;; Handles sequences of statements
(define (eval-seq e1 e2 env)
  (let* ((seq1 (evaluate e1 env))
         (seq2 (evaluate e2 (cdr seq1))))
    seq2))
