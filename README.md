# Decentralized Manufacturing Production Planning

A blockchain-based production planning system built with Clarity smart contracts for the Stacks blockchain. This system provides decentralized management of manufacturing operations including production manager verification, demand forecasting, capacity planning, schedule optimization, and resource allocation.

## Features

### 🏭 Production Manager Verification
- Validates and manages production managers
- Certification level tracking
- Department-based organization
- Revocation capabilities

### 📊 Demand Forecasting
- Product demand predictions
- Confidence level tracking
- Historical data analysis
- Period-based forecasting

### ⚡ Capacity Planning
- Facility capacity management
- Utilization rate calculations
- Efficiency tracking
- Multi-facility support

### 📅 Schedule Optimization
- Production schedule creation
- Conflict detection and resolution
- Priority-based scheduling
- Status tracking

### 🔧 Resource Allocation
- Inventory management
- Resource allocation tracking
- Utilization calculations
- Cost management

## Smart Contracts

### 1. Production Manager Verification (\`production-manager-verification.clar\`)
Manages the verification and authorization of production managers.

**Key Functions:**
- \`verify-manager\`: Add a new verified production manager
- \`revoke-manager\`: Remove manager verification
- \`is-verified-manager\`: Check if a manager is verified
- \`get-manager-details\`: Retrieve manager information

### 2. Demand Forecasting (\`demand-forecasting.clar\`)
Handles production demand forecasting and historical tracking.

**Key Functions:**
- \`create-forecast\`: Create a new demand forecast
- \`update-forecast\`: Update existing forecast
- \`get-demand-forecast\`: Retrieve forecast data
- \`get-product-history\`: Get historical demand data

### 3. Capacity Planning (\`capacity-planning.clar\`)
Manages production facility capacity and utilization.

**Key Functions:**
- \`register-facility\`: Register a new production facility
- \`set-capacity\`: Set facility capacity for a period
- \`allocate-capacity\`: Allocate capacity to production
- \`calculate-utilization-rate\`: Calculate capacity utilization

### 4. Schedule Optimization (\`schedule-optimization.clar\`)
Optimizes production schedules and manages conflicts.

**Key Functions:**
- \`create-schedule\`: Create a new production schedule
- \`update-schedule-status\`: Update schedule status
- \`optimize-schedule\`: Optimize facility schedules
- \`get-conflicts\`: Retrieve schedule conflicts

### 5. Resource Allocation (\`resource-allocation.clar\`)
Manages production resource inventory and allocation.

**Key Functions:**
- \`add-resource\`: Add resources to inventory
- \`allocate-resource\`: Allocate resources to production
- \`release-resource\`: Release allocated resources
- \`calculate-resource-utilization\`: Calculate resource utilization

## Getting Started

### Prerequisites
- Stacks blockchain node
- Clarity CLI tools
- Node.js (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd manufacturing-production-planning
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks blockchain:

\`\`\`bash
# Deploy production manager verification
clarinet deploy contracts/production-manager-verification.clar

# Deploy demand forecasting
clarinet deploy contracts/demand-forecasting.clar

# Deploy capacity planning
clarinet deploy contracts/capacity-planning.clar

# Deploy schedule optimization
clarinet deploy contracts/schedule-optimization.clar

# Deploy resource allocation
clarinet deploy contracts/resource-allocation.clar
\`\`\`

## Usage Examples

### Verify a Production Manager
\`\`\`clarity
(contract-call? .production-manager-verification verify-manager
'SP1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE
"John Smith"
"Assembly"
u5)
\`\`\`

### Create a Demand Forecast
\`\`\`clarity
(contract-call? .demand-forecasting create-forecast
"WIDGET-001"
u202401
u1000
u85)
\`\`\`

### Set Facility Capacity
\`\`\`clarity
(contract-call? .capacity-planning set-capacity
"FAC-001"
u202401
u5000
u90)
\`\`\`

### Create Production Schedule
\`\`\`clarity
(contract-call? .schedule-optimization create-schedule
"WIDGET-001"
"FAC-001"
u202401
u202402
u1000
u8)
\`\`\`

### Allocate Resources
\`\`\`clarity
(contract-call? .resource-allocation allocate-resource
"STEEL"
"FAC-001"
u1
u500)
\`\`\`

## Testing

The project includes comprehensive tests using Vitest:

\`\`\`bash
# Run all tests
npm test

# Run specific test file
npm test -- production-manager-verification.test.js

# Run tests in watch mode
npm run test:watch
\`\`\`

## Architecture

The system follows a modular architecture with separate contracts for each major function:

1. **Manager Verification**: Ensures only authorized personnel can make critical decisions
2. **Demand Forecasting**: Provides data-driven production planning
3. **Capacity Planning**: Optimizes facility utilization
4. **Schedule Optimization**: Minimizes conflicts and maximizes efficiency
5. **Resource Allocation**: Ensures optimal resource utilization

## Security Considerations

- All critical functions require proper authorization
- Input validation on all public functions
- Overflow protection on arithmetic operations
- Access control for sensitive operations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in the GitHub repository.

