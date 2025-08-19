# Azure VNET for F5 XC Cloud Ingress/Egress Gateway Site

This example demonstrates how to create an Azure Virtual Network (VNET) optimized for F5 Distributed Cloud (XC) Ingress/Egress Gateway deployments. It provisions a complete networking foundation with multi-availability zone support and pre-configured security groups.

## Architecture Overview

This example creates:

- **Azure VNET**: A virtual network with configurable CIDR blocks
- **Outside Subnets**: 3 subnets across availability zones for external traffic
- **Inside Subnets**: 3 subnets across availability zones for internal traffic
- **Network Security Groups**: Pre-configured with F5 XC IP ranges
- **Multi-AZ Design**: Distributed across 3 availability zones for high availability

## Prerequisites

1. **Azure Subscription**: Active Azure subscription with appropriate permissions
2. **Terraform**: Version >= 1.4.0
3. **Azure CLI**: Configured with appropriate credentials (optional if using service principal)
4. **Existing Resource Group**: This example uses an existing resource group

## Configuration

### 1. Authentication

This example supports two authentication methods:

#### Option A: Azure CLI (Recommended for development)
```bash
az login
az account set --subscription "your-subscription-id"
```

#### Option B: Service Principal (Recommended for CI/CD)
Configure the variables in `terraform.tfvars`:
```hcl
azure_subscription_id             = "your-subscription-id"
azure_subscription_tenant_id      = "your-tenant-id"
azure_service_principal_appid     = "your-app-id"
azure_service_principal_password  = "your-password"
```

### 2. Variables Configuration

Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:
```hcl
azure_subscription_id        = "12345678-1234-1234-1234-123456789abc"
azure_subscription_tenant_id = "87654321-4321-4321-4321-cba987654321"
azure_rg_location            = "West US 2"
```

## Usage

### Quick Start

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review the plan**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

4. **Clean up** (when done):
   ```bash
   terraform destroy
   ```

### Example Configuration

```hcl
module "azure_vnet" {
  source = "../.."

  create_resource_group = false
  resource_group_name   = "azure_terraform_demo"
  location              = var.azure_rg_location
  vnet_cidr             = "192.168.0.0/16"
  outside_subnets       = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets        = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]

  tags = {
    Environment = "demo"
    Project     = "f5-xc-gateway"
    Example     = "ingress-egress-gw"
  }
}
```

## Network Design

### Subnets

| Subnet Type | CIDR Blocks                                           | Purpose                          | Availability Zones |
| ----------- | ----------------------------------------------------- | -------------------------------- | ------------------ |
| Outside     | 192.168.11.0/24<br>192.168.12.0/24<br>192.168.13.0/24 | External traffic, load balancers | AZ1, AZ2, AZ3      |
| Inside      | 192.168.21.0/24<br>192.168.22.0/24<br>192.168.23.0/24 | Internal applications, workloads | AZ1, AZ2, AZ3      |

### Security Groups

The module automatically creates Network Security Groups with:
- **F5 XC Regional Access**: Allow traffic from F5 Distributed Cloud IP ranges
- **VNET Communication**: Allow internal communication between subnets
- **Default Deny**: Block all other inbound traffic

## Outputs

After deployment, the following outputs are available:

| Output                | Description                               |
| --------------------- | ----------------------------------------- |
| `vnet_name`           | Name of the created VNET                  |
| `vnet_id`             | Azure resource ID of the VNET             |
| `vnet_cidr`           | CIDR block of the VNET                    |
| `outside_subnet_ids`  | List of outside subnet IDs                |
| `inside_subnet_ids`   | List of inside subnet IDs                 |
| `location`            | Azure region where resources were created |
| `resource_group_name` | Resource group name                       |

### Accessing Outputs

```bash
# Get all outputs
terraform output

# Get specific output
terraform output vnet_name
terraform output outside_subnet_ids
```

## Customization

### Different Regions

To deploy in a different Azure region:

```hcl
variable "azure_rg_location" {
  type    = string
  default = "East US"  # Change to your preferred region
}
```

### Custom CIDR Blocks

To use different IP ranges:

```hcl
vnet_cidr       = "10.0.0.0/16"
outside_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
inside_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
```

### Additional Subnets

To add local subnets:

```hcl
local_subnets = ["192.168.31.0/24", "192.168.32.0/24", "192.168.33.0/24"]
```

## Validation

### Verify Resources

1. **Check VNET creation**:
   ```bash
   az network vnet list --resource-group azure_terraform_demo --output table
   ```

2. **Verify subnets**:
   ```bash
   az network vnet subnet list --resource-group azure_terraform_demo --vnet-name <vnet-name> --output table
   ```

3. **Check security groups**:
   ```bash
   az network nsg list --resource-group azure_terraform_demo --output table
   ```

### Test Connectivity

After deployment, you can:
1. Deploy F5 XC Site instances in the outside subnets
2. Deploy application workloads in the inside subnets
3. Verify connectivity according to your F5 XC site configuration

## Next Steps

After deploying this networking foundation:

1. **Deploy F5 XC Site**: Use the created subnets for your F5 Distributed Cloud site
2. **Configure Applications**: Deploy your applications in the inside subnets
3. **Set up Monitoring**: Configure Azure Monitor and Network Watcher
4. **Implement Additional Security**: Add custom NSG rules if needed
