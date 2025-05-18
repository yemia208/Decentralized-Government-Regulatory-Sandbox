# Decentralized Government Regulatory Sandbox

A blockchain-based regulatory sandbox implemented using Clarity smart contracts. This system enables governments to create controlled environments where businesses can test innovative products, services, or business models without immediately incurring all the normal regulatory consequences.

## Overview

This project implements a decentralized regulatory sandbox with the following components:

1. **Entity Verification**: Validates participating businesses
2. **Innovation Registration**: Records experimental concepts
3. **Regulatory Waiver**: Manages temporary exemptions
4. **Testing Boundary**: Defines operational constraints
5. **Outcome Measurement**: Tracks innovation results

## Smart Contracts

### Entity Verification Contract

Manages the verification of businesses that want to participate in the regulatory sandbox.

Key functions:
- `register-entity`: Allows businesses to register themselves
- `verify-entity`: Admin can verify a registered entity
- `reject-entity`: Admin can reject an entity
- `is-verified`: Check if an entity is verified

### Innovation Registration Contract

Records and manages innovative concepts that entities want to test in the sandbox.

Key functions:
- `register-innovation`: Verified entities can register new innovations
- `approve-innovation`: Admin can approve an innovation
- `reject-innovation`: Admin can reject an innovation
- `complete-innovation`: Mark an innovation as completed

### Regulatory Waiver Contract

Manages temporary exemptions from specific regulations for approved innovations.

Key functions:
- `request-waiver`: Innovation owners can request regulatory waivers
- `approve-waiver`: Admin can approve waivers with a specified duration
- `reject-waiver`: Admin can reject waiver requests
- `expire-waiver`: Mark a waiver as expired

### Testing Boundary Contract

Defines operational constraints for innovations in the sandbox.

Key functions:
- `add-boundary`: Admin can add boundaries (user limits, transaction limits, etc.)
- `update-boundary`: Admin can update existing boundaries
- `remove-boundary`: Admin can remove boundaries

### Outcome Measurement Contract

Tracks the results and metrics of innovations in the sandbox.

Key functions:
- `add-measurement`: Innovation owners or admins can add measurements
- `update-measurement`: Update existing measurements
- `get-measurements-for-innovation`: Get all measurements for a specific innovation

## Getting Started

### Prerequisites

- A Clarity-compatible blockchain environment
- Basic understanding of Clarity smart contracts

### Deployment

1. Deploy the contracts in the following order:
    - Entity Verification
    - Innovation Registration
    - Regulatory Waiver
    - Testing Boundary
    - Outcome Measurement

2. Set up the admin principal for each contract

### Usage Flow

1. Entities register themselves
2. Admin verifies entities
3. Verified entities register innovations
4. Admin approves innovations
5. Innovation owners request regulatory waivers
6. Admin approves waivers and sets boundaries
7. Innovation owners and admins track outcomes with measurements

## Testing

Tests are implemented using Vitest. To run the tests:

\`\`\`bash
npm test
\`\`\`

## License

This project is licensed under the MIT License - see the LICENSE file for details.
