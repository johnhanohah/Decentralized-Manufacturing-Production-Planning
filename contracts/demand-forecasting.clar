;; Demand Forecasting Contract
;; Manages production demand forecasts

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u200))
(define-constant err-unauthorized (err u201))
(define-constant err-invalid-forecast (err u202))
(define-constant err-forecast-exists (err u203))

;; Data maps
(define-map demand-forecasts
    {product-id: (string-ascii 20), period: uint}
    {
        forecasted-demand: uint,
        confidence-level: uint,
        created-by: principal,
        created-at: uint,
        updated-at: uint
    }
)

(define-map product-history
    (string-ascii 20)
    {
        total-forecasts: uint,
        avg-demand: uint,
        last-updated: uint
    }
)

;; Read-only functions
(define-read-only (get-demand-forecast (product-id (string-ascii 20)) (period uint))
    (map-get? demand-forecasts {product-id: product-id, period: period})
)

(define-read-only (get-product-history (product-id (string-ascii 20)))
    (map-get? product-history product-id)
)

;; Public functions
(define-public (create-forecast (product-id (string-ascii 20)) (period uint) (demand uint) (confidence uint))
    (let ((forecast-key {product-id: product-id, period: period}))
        (begin
            (asserts! (> demand u0) err-invalid-forecast)
            (asserts! (<= confidence u100) err-invalid-forecast)
            (asserts! (is-none (map-get? demand-forecasts forecast-key)) err-forecast-exists)

            (map-set demand-forecasts forecast-key {
                forecasted-demand: demand,
                confidence-level: confidence,
                created-by: tx-sender,
                created-at: block-height,
                updated-at: block-height
            })

            ;; Update product history
            (match (map-get? product-history product-id)
                existing-history
                    (map-set product-history product-id {
                        total-forecasts: (+ (get total-forecasts existing-history) u1),
                        avg-demand: (/ (+ (* (get avg-demand existing-history) (get total-forecasts existing-history)) demand)
                                      (+ (get total-forecasts existing-history) u1)),
                        last-updated: block-height
                    })
                (map-set product-history product-id {
                    total-forecasts: u1,
                    avg-demand: demand,
                    last-updated: block-height
                })
            )
            (ok true)
        )
    )
)

(define-public (update-forecast (product-id (string-ascii 20)) (period uint) (demand uint) (confidence uint))
    (let ((forecast-key {product-id: product-id, period: period}))
        (begin
            (asserts! (> demand u0) err-invalid-forecast)
            (asserts! (<= confidence u100) err-invalid-forecast)
            (asserts! (is-some (map-get? demand-forecasts forecast-key)) err-invalid-forecast)

            (map-set demand-forecasts forecast-key {
                forecasted-demand: demand,
                confidence-level: confidence,
                created-by: tx-sender,
                created-at: block-height,
                updated-at: block-height
            })
            (ok true)
        )
    )
)
