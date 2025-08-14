;; title: cross-chain-asset-bridge
;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-UNAUTHORIZED (err u1))
(define-constant ERR-INSUFFICIENT-BALANCE (err u2))
(define-constant ERR-TRANSFER-FAILED (err u3))
(define-constant ERR-INVALID-CHAIN (err u4))
(define-constant ERR-LIQUIDITY-INSUFFICIENT (err u5))
(define-constant ERR-ASSET-NOT-FOUND (err u6))
(define-constant ERR-ASSET-ALREADY-REGISTERED (err u7))


;; Supported Chains Enum
(define-constant CHAIN-BITCOIN u1)
(define-constant CHAIN-ETHEREUM u2)
(define-constant CHAIN-STACKS u3)


;; Bridge Transaction States
(define-constant TX-PENDING u0)
(define-constant TX-CONFIRMED u1)
(define-constant TX-COMPLETED u2)

;; Cross-Chain Asset Mapping
(define-map CrossChainAssets
  {
    asset-id: (buff 32),
    source-chain: uint,
    destination-chain: uint
  }
  {
    amount: uint,
    sender: principal,
    receiver: principal,
    status: uint,
    timestamp: uint
  }
)

;; Supported Assets Registry
(define-map SupportedAssets
  (buff 32)  ;; Asset Identifier
  {
    name: (string-ascii 50),
    decimals: uint,
    is-enabled: bool
  }
)

;; Bridge Liquidity Pool
(define-map BridgeLiquidityPool
  (buff 32)  ;; Asset Identifier 
  {
    total-liquidity: uint,
    available-liquidity: uint
  }
)

;; Register New Supported Asset
(define-public (register-asset
  (asset-id (buff 32))
  (name (string-ascii 50))
  (decimals uint)
)
  (begin
    ;; Only contract owner can register assets
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)
    
    (map-set SupportedAssets 
      asset-id 
      {
        name: name,
        decimals: decimals,
        is-enabled: true
      }
    )
    
    (ok true)
  )
)

