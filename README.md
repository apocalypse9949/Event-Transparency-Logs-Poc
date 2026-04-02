# RubyGems Transparency Log PoC

A proof-of-concept for a tamper-proof, append-only transparency log modeled after Certificate Transparency. This system uses a combination of **Hash Chaining** and **Merkle Trees** to ensure chronological integrity and provide efficient proofs of inclusion for registry events.

##  Overview

This application simulates a package registry (like RubyGems) where every significant action—such as pushing a new gem version or changing owners—is recorded in a verifiable, immutable log.

### Key Features:
- **Immutable Log**: Every `RegistryEvent` is cryptographically linked to the previous one using SHA-256 hash chaining.
- **Merkle Tree Proofs**: Highly efficient verification of event inclusion using Merkle Trees (RFC 6962 compliant).
- **Auditability**: A dedicated verification script to ensure the entire chain is intact.
- **REST API**: Endpoints to retrieve events and their inclusion proofs.

##  Architecture

### 1. Hash Chaining (Linear Integrity)
Each `RegistryEvent` contains a `previous_hash` field, which is the SHA-256 hash of the immediately preceding event. If any past property of an event is modified, all subsequent hashes in the chain will break.

### 2. Merkle Tree (Efficient Auditing)
While linear chaining ensures integrity, Merkle Trees allow clients to verify that a specific event exists in the log without downloading the entire history.

**Log Consistency**: As new events are added, a new Merkle Root is calculated.
**Inclusion Proof**: A compact list of intermediate hashes that allow a client to reconstruct the root from their specific event hash.

##  Getting Started

### Prerequisites:
- Ruby 3.2.x
- Rails 7.x
- SQLite3

### Setup:
```bash
# Install dependencies
bundle install

# Setup database
rails db:migrate
rails db:seed
```

##  Verification & Results

The system includes a verification script that audits the entire log and generates cryptographic proofs.

### Running the Auditor:
```bash
ruby verify_merkle.rb
```

### Sample Output:
```text
Total RegistryEvents: 8
Event 1: Root event (Prev: 0000000000000000000000000000000000000000000000000000000000000000)
Event 2: Chaining is VALID
Event 3: Chaining is VALID
Event 4: Chaining is VALID
Event 5: Chaining is VALID
Event 6: Chaining is VALID
Event 7: Chaining is VALID
Event 8: Chaining is VALID

Computed Merkle Root: 4e768e1a100523097bf89f36f3226db97fba128a38450fdf588ae38290376ab1

Generated proof for Event 3 (index 2)
Inclusion Proof status: SUCCESS
```

##  Core Components

- **`RegistryEvent`**: The core data model representing an entry in the log.
- **`MerkleTreeService`**: A stateless service that implements the Merkle algorithm (tree building, proof generation, and verification).
- **`app/controllers/api/v1`**: API endpoints for external auditing.


