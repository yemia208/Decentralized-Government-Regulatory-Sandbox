;; Simple Regulatory Sandbox Contract
;; A streamlined contract for managing regulatory sandbox participants and innovations

;; ----- Data Variables -----
(define-data-var admin principal tx-sender)

;; ----- Data Maps -----

;; Entity map: tracks registered businesses
(define-map entities principal
  {
    name: (string-ascii 100),
    is-verified: bool,
    registration-date: uint
  }
)

;; Innovation map: tracks experimental concepts
(define-map innovations uint
  {
    owner: principal,
    title: (string-ascii 100),
    description: (string-utf8 500),
    is-approved: bool,
    has-waiver: bool,
    registration-date: uint
  }
)

;; Counter for innovation IDs
(define-data-var innovation-counter uint u0)

;; ----- Read-Only Functions -----

;; Check if an entity is verified
(define-read-only (is-entity-verified (entity principal))
  (default-to false
    (get is-verified (map-get? entities entity))
  )
)

;; Get entity details
(define-read-only (get-entity-details (entity principal))
  (map-get? entities entity)
)

;; Get innovation details
(define-read-only (get-innovation-details (id uint))
  (map-get? innovations id)
)

;; Get total innovations count
(define-read-only (get-innovation-count)
  (var-get innovation-counter)
)

;; ----- Public Functions -----

;; Register a new entity (self-registration)
(define-public (register-entity (name (string-ascii 100)))
  (begin
    (asserts! (not (is-some (map-get? entities tx-sender))) (err u1)) ;; Entity already exists
    (ok (map-set entities tx-sender
      {
        name: name,
        is-verified: false,
        registration-date: block-height
      }
    ))
  )
)

;; Verify an entity (admin only)
(define-public (verify-entity (entity principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403)) ;; Not authorized
    (asserts! (is-some (map-get? entities entity)) (err u404)) ;; Entity not found
    (match (map-get? entities entity)
      entity-data
        (ok (map-set entities entity
          (merge entity-data { is-verified: true })
        ))
      (err u404)
    )
  )
)

;; Register a new innovation
(define-public (register-innovation (title (string-ascii 100)) (description (string-utf8 500)))
  (begin
    (asserts! (is-entity-verified tx-sender) (err u401)) ;; Entity not verified
    (var-set innovation-counter (+ (var-get innovation-counter) u1))
    (ok (map-set innovations (var-get innovation-counter)
      {
        owner: tx-sender,
        title: title,
        description: description,
        is-approved: false,
        has-waiver: false,
        registration-date: block-height
      }
    ))
  )
)

;; Approve an innovation (admin only)
(define-public (approve-innovation (id uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403)) ;; Not authorized
    (asserts! (is-some (map-get? innovations id)) (err u404)) ;; Innovation not found
    (match (map-get? innovations id)
      innovation-data
        (ok (map-set innovations id
          (merge innovation-data { is-approved: true })
        ))
      (err u404)
    )
  )
)

;; Grant regulatory waiver (admin only)
(define-public (grant-waiver (id uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403)) ;; Not authorized
    (asserts! (is-some (map-get? innovations id)) (err u404)) ;; Innovation not found
    (match (map-get? innovations id)
      innovation-data
        (begin
          (asserts! (get is-approved innovation-data) (err u400)) ;; Innovation not approved
          (ok (map-set innovations id
            (merge innovation-data { has-waiver: true })
          ))
        )
      (err u404)
    )
  )
)

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403)) ;; Not authorized
    (ok (var-set admin new-admin))
  )
)
