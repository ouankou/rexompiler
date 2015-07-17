(define-fun cand ((i1 Int) (i2 Int)) Int (ite (and (distinct i1 0) (distinct i2 0)) 1 0))
(define-fun cor ((i1 Int) (i2 Int)) Int (ite (or (distinct i1 0) (distinct i2 0)) 1 0))
(define-fun cnot ((i1 Int)) Int (ite (distinct i1 0) 0 1))

(define-fun cgeq ((a Int) (b Int)) Int (ite (>= a b) 1 0))
(define-fun cgt ((a Int) (b Int)) Int (ite (> a b) 1 0))

(define-fun cleq ((a Int) (b Int)) Int (ite (<= a b) 1 0))
(define-fun clt ((a Int) (b Int)) Int (ite (< a b) 1 0))

(define-fun ceq ((a Int) (b Int)) Int (ite (= a b) 1 0))
(define-fun cneq ((a Int) (b Int)) Int (ite (distinct a b) 1 0))

(assert (= (cgeq 1 0) 1))
(assert (= (cgeq 0 0) 1))
(assert (= (cleq 0 1) 1))
(assert (= (cleq 0 0) 1))
(assert (= (cgt 1 0) 1))
(assert (= (clt 0 1) 1))
(assert (= (ceq 1 1) 1))
(assert (= (cneq 1 0) 1))
(check-sat)
(push)
(assert (= (cgeq 0 1) 1))
(check-sat)
(pop)
(push)
(assert (= (cgt 0 0) 1))
(check-sat)
(pop)
(push)
(assert (= (cleq 1 0) 1))
(check-sat)
(pop)
(push)
(assert (= (clt 0 0) 1))
(check-sat)
(pop)
(push)
(assert (= (ceq 0 1) 1))
(check-sat)
(pop)
(push)
(assert (= (cgeq 0 1) 1))
(check-sat)
(pop)
(push)
(assert (= (cneq 0 0) 1))
(check-sat)
(pop)
(push)
(assert (= (cgeq 0 1) 0))
(assert (= (cgt 0 0) 0))
(assert (= (cgt 0 1) 0))
(assert (= (clt 0 0) 0))
(assert (= (clt 1 0) 0))
(assert (= (cneq 0 0) 0))
(assert (= (ceq 0 1) 0))

(check-sat)
(pop)


(push)
(assert (= (cgeq 1 0) 0))
(check-sat)
(pop)
(push)
(assert (= (cgt 1 0) 0))
(check-sat)
(pop)
(push)
(assert (= (cleq 0 1) 0))
(check-sat)
(pop)
(push)
(assert (= (clt 0 1) 0))
(check-sat)
(pop)
(push)
(assert (= (ceq 1 1) 0))
(check-sat)
(pop)
(push)
(assert (= (cgeq 1 0) 0))
(check-sat)
(pop)
(push)
(assert (= (cneq 1 0) 0))
(check-sat)
(pop)
(push)
(assert (= (ceq 0 0) 0))
(check-sat)
(pop)


(push)
(assert (= (cand 0 1) 1))
(check-sat)
(pop)
(push)
(assert (= (cand 0 0) 1))
(check-sat)
(pop)
(push)
(assert (= (cand 1 0) 1))
(check-sat)
(pop)
(push)
(assert (= (cand 1 1) 1))
(assert (= (cand 0 0) 0))
(check-sat)
(pop)
(push)
(assert (= (cor 1 1) 1))
(assert (= (cor 1 0) 1))
(assert (= (cor 0 1) 1))
(check-sat)
(pop)
(push)
(assert (= (cor 0 0) 1))
(check-sat)
(pop)
(push)
(assert (= (cnot 1) 0))
(check-sat)
(pop)
(push)
(assert (= (cnot 10) 1))
(check-sat)
(pop)
(push)
(assert (= (cnot 0) 1))
(check-sat)
(pop)
