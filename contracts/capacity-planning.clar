;; Capacity Planning Contract
;; Plans and manages production capacity

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u300))
(define-constant err-invalid-capacity (err u301))
(define-constant err-capacity-exists (err u302))
(define-constant err-insufficient-capacity (err u303))

;; Data maps
(define-map production-capacity
    {facility-id: (string-ascii 20), period: uint}
    {
        max-capacity: uint,
        available-capacity: uint,
        utilized-capacity: uint,
        efficiency-rate: uint,
        updated-at: uint
    }
)

(define-map facility-info
    (string-ascii 20)
    {
        name: (string-ascii 50),
        location: (string-ascii 30),
        total-lines: uint,
        active-lines: uint
    }
)

;; Read-only functions
(define-read-only (get-capacity (facility-id (string-ascii 20)) (period uint))
    (map-get? production-capacity {facility-id: facility-id, period: period})
)

(define-read-only (get-facility-info (facility-id (string-ascii 20)))
    (map-get? facility-info facility-id)
)

(define-read-only (calculate-utilization-rate (facility-id (string-ascii 20)) (period uint))
    (match (map-get? production-capacity {facility-id: facility-id, period: period})
        capacity-data
            (if (> (get max-capacity capacity-data) u0)
                (some (/ (* (get utilized-capacity capacity-data) u100) (get max-capacity capacity-data)))
                none
            )
        none
    )
)

;; Public functions
(define-public (register-facility (facility-id (string-ascii 20)) (name (string-ascii 50)) (location (string-ascii 30)) (total-lines uint))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (> total-lines u0) err-invalid-capacity)

        (map-set facility-info facility-id {
            name: name,
            location: location,
            total-lines: total-lines,
            active-lines: total-lines
        })
        (ok true)
    )
)

(define-public (set-capacity (facility-id (string-ascii 20)) (period uint) (max-cap uint) (efficiency uint))
    (let ((capacity-key {facility-id: facility-id, period: period}))
        (begin
            (asserts! (> max-cap u0) err-invalid-capacity)
            (asserts! (<= efficiency u100) err-invalid-capacity)

            (map-set production-capacity capacity-key {
                max-capacity: max-cap,
                available-capacity: max-cap,
                utilized-capacity: u0,
                efficiency-rate: efficiency,
                updated-at: block-height
            })
            (ok true)
        )
    )
)

(define-public (allocate-capacity (facility-id (string-ascii 20)) (period uint) (required-capacity uint))
    (let ((capacity-key {facility-id: facility-id, period: period}))
        (match (map-get? production-capacity capacity-key)
            existing-capacity
                (let ((new-available (- (get available-capacity existing-capacity) required-capacity))
                      (new-utilized (+ (get utilized-capacity existing-capacity) required-capacity)))
                    (begin
                        (asserts! (>= (get available-capacity existing-capacity) required-capacity) err-insufficient-capacity)

                        (map-set production-capacity capacity-key {
                            max-capacity: (get max-capacity existing-capacity),
                            available-capacity: new-available,
                            utilized-capacity: new-utilized,
                            efficiency-rate: (get efficiency-rate existing-capacity),
                            updated-at: block-height
                        })
                        (ok true)
                    )
                )
            err-invalid-capacity
        )
    )
)
