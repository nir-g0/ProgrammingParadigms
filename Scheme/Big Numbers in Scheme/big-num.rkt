#lang racket

;; The big-num data structure is essentially a list of 3 digit numbers.

;; Exporting methods
(provide big-add big-subtract big-multiply big-power-of pretty-print
         number->bignum string->bignum bignum? zero-or-one? one-block?)

(define MAX_BLOCK 1000)

;; Contract verifying the datatype of a bignum
(define (bignum? n)
  (cond [(not (list? n)) #f]
        [(not (list-of-ints? n)) #f]
        [else #t]))

;; Helper contract
(define (list-of-ints? lst)
  (cond [(empty? lst) #t]
        [(integer? (car lst)) (list-of-ints? (cdr lst))]
        [else #f]))

;; Contract to ensure a number is 0 or 1.
(define (zero-or-one? n)
  (match n
    [0 #t]
    [1 #t]
    [_ #f]))

;; Contract to insure a number is an integer in the range of 0-999.
(define (one-block? n)
  (and (integer? n)
       (>= n 0)
       (< n 1000)))

(define/contract (big-add x y)
  (-> bignum? bignum? bignum?)
  (big-add1 x y 0)
  )

(define/contract (big-add1 x y co)
  (-> bignum? bignum? zero-or-one? bignum?)
  (cond
    ;; If both lists are empty, the return value is either 0 or the caryover value.
    [(and (= 0 (length x)) (= 0 (length y)))
      (if (= co 0) '() (list co))] ;; if carry over is 0, return empty list, else return the carry over as a list
    [(= 0 (length x))  (big-add1 (list co) y 0)] ;;list x is of length 0, add carry over and y
    [(= 0 (length y))  (big-add1 x (list co) 0)] ;;list y is of length 0, add carry over and x
    [else
       (let* ([sum (+ (car x) (car y) co)]
              [carry (if{>= sum MAX_BLOCK} 1 0)])
       (cons (modulo sum MAX_BLOCK) (big-add1 [cdr x] [cdr y] carry)))
     ]
    ))

;; Subtraction of two big-nums
(define/contract (big-subtract x y)
  (-> bignum? bignum? bignum?)
  (let ([lst (big-subtract1 x y 0)])
    (reverse (strip-leading-zeroes (reverse lst)))
  ))

(define/contract (strip-leading-zeroes x)
  (-> bignum? bignum?)
  (cond
    [(= 0 (length x)) '(0)]
    [(= 0 (car x)) (strip-leading-zeroes (cdr x))]
    [else x]
    ))

;; NOTE: there are no negative numbers with this implementation,
;; so 3 - 4 should throw an error.
(define/contract (big-subtract1 x y borrow)
  (-> bignum? bignum? zero-or-one? bignum?)
   (cond
    ;; If both lists are empty, the return value is either 0 or the caryover value.
    [(and (= 0 (length x)) (= 0 (length y)))
      (if (= borrow 0) '() (list borrow))] ;; if carry over is 0, return empty list, else return the carry over as a list
    [(= 0 (length x))  (big-subtract1 (list borrow) y 0)] ;;list x is of length 0, add carry over and y
    [(= 0 (length y))  (big-subtract1 x (list borrow) 0)] ;;list y is of length 0, add carry over and x
    [else
       (let* ([new-x (- (car x) borrow)]
              [diff {if (< new-x (car y))[- (+ MAX_BLOCK new-x) (car y)][- new-x (car y)]}]
              [borrow {if (< new-x (car y)) 1 0}]
             )
       (cons (modulo diff MAX_BLOCK) (big-subtract1 [cdr x] [cdr y] borrow)))
     ]
    ))

;; Returns true if two big-nums are equal
(define/contract (big-eq x y)
  (-> bignum? bignum? boolean?)
  (andmap (lambda (el-x el-y) (= el-x el-y)) x y)
  )


;; Decrements a bignum
(define/contract (big-dec x)
  (-> bignum? bignum?)
  (big-subtract x '(1))
  )

;; Multiplies two big-nums
(define/contract (big-multiply x y)
  (-> bignum? bignum? bignum?)
  (cond [(null? x) '(0)]
        [(or (equal? x '(0)) (equal? y '(0))) '(0)]
  {else 
    {big-add (big-multiply1 (car x) y 0) (big-multiply (cdr x) [cons 0 y])}})
 )

(define (big-multiply1 multiplier y co)
   (cond
    [(= 0 (length y))  (if (> co 0) (list co) '())] ;;list y is of length 0, add carry over
    [else
     (let* ([prod (+ (* multiplier [car y]) co)]
       [carry (quotient prod MAX_BLOCK)]
       )
       (cons [modulo prod MAX_BLOCK] [big-multiply1 multiplier (cdr y) carry]))
     ]
   )
)

;; Raise x to the power of y
(define/contract (big-power-of x y)
  (-> bignum? bignum? bignum?)
  (cond
    [(equal? y '(1)) x]
    [else
     (big-multiply x (big-power-of x (big-dec y)))]))


;; Dispaly a big-num in an easy to read format
(define (pretty-print x)
  (let ([lst (reverse x)])
    (string-append
     (number->string (car lst))
     (pretty-print1 (cdr lst))
     )))

(define (pretty-print1 x)
  (cond
    [(= 0 (length x))  ""]
    [else
     (string-append (pretty-print-block (car x)) (pretty-print1 (cdr x)))]
    ))

(define (pretty-print-block x)
  (string-append
   ","
   (cond
     [(< x 10) "00"]
     [(< x 100) "0"]
     [else ""])
   (number->string x)))

;; Convert a number to a bignum
(define/contract (number->bignum n)
  (-> number? bignum?)
  (cond
    [(< n MAX_BLOCK) (list n)]
    [else
     (let ([block (modulo n MAX_BLOCK)]
           [rest (floor (/ n MAX_BLOCK))])
       (cons block (number->bignum rest)))]))

;; Convert a string to a bignum
(define/contract (string->bignum s)
  (-> string? bignum?)
  (let ([n (string->number s)])
    (number->bignum n)))

