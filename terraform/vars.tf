variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type      = string
  sensitive = true
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  description = "Mi llave pública para entrar a las VMs"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAXmpRbnDaAdbaKHwK+UyzVHUFxAMJVvMGnbnxf0Ty0D7+Y0FRmpSA66BfKjXs5UIgaUGsQDwhzRlNKGN2XvKekBB2Y3mbzlBZ8YIP7RE2xR3XiuxQAOPMfWiqFyYO2x3U0kj8PxAl8kmmPD+bLBk04ADQMFWLpx+1Xeu/5kAaNkCO5cJ0f0HI+Oj0DiJfMExS0rUedj82IIjen2gG1Tz2rZQhJxf0L8IjTStFvsczRLoA6FUa5HF7g+zq3gxz2VaTVT51PaY67J4c3H54s4uDEeBJdwkrDtsByNyZ2t71tDBsAx8A4Nx3hCn429WFt2aN+oWQFIXB0xaEn0lLDiW5vl5ai0XoS4Ndw4yCXcnkwCWwWTEATxc9ZI2wOxeZM+KXr3/exCJWG0+LPtQAHIv/7mvh8NLyCiukR/L+vFbqB/uroF793KZgg9e7R9Li8iqKzHSUMwtQ2+YzEmDhEZpqw0bNfBLsF7aN6v/WmWkzlAtfKwXVPMte+MWn8wJkIxk= dagomez@Daniels-Air.fibertel.com.ar"
}



